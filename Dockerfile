FROM jupyterhub/singleuser:latest

USER root

# 1. 安装 code-server
# 这里使用官方脚本安装，也可以手动下载 deb/rpm 包以节省构建时间
RUN apt-get update && \
    apt-get install -y curl htop git less build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://code-server.dev/install.sh | sh

# 2. 安装必要的 Python 插件来桥接 Jupyter 和 VS Code
# jupyter-server-proxy: 提供端口转发功能
# jupyter-vscode-proxy: 自动在 Jupyter 界面添加 VS Code 图标和启动项
RUN chown -R ${NB_USER}:users /home/jovyan
USER ${NB_USER}

RUN pip install --no-cache-dir \
    jupyter-server-proxy \
    jupyter-vscode-proxy

# 3. (可选) 预装一些常用的 VS Code 扩展
# 例如 Python 插件

RUN code-server --install-extension ms-python.python

# 暴露端口（JupyterHub 默认使用 8888）
EXPOSE 8888

# 切换回默认工作目录
WORKDIR /home/jovyan