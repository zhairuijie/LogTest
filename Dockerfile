# FROM ubuntu:20.04

# # RUN useradd -m -u 1000 -s /bin/bash faas

# COPY main /opt/application/main
# COPY run.sh /opt/application/run.sh

# WORKDIR /opt/application
# USER root
# CMD /opt/application/run.sh
FROM public-cn-beijing.cr.volces.com/public/base:golang-1.17.1-alpine3.14 as builder
# 指定构建过程中的工作目录
WORKDIR /app
# 将当前目录（dockerfile所在目录）下所有文件都拷贝到工作目录下（.dockerignore中文件除外）
COPY . /app/

# 执行代码编译命令。操作系统参数为linux，编译后的二进制产物命名为main，并存放在当前目录下。
RUN GOPROXY=https://goproxy.cn,direct GOOS=linux go build -o main .
FROM public-cn-beijing.cr.volces.com/public/base:alpine-3.13
WORKDIR /opt/application
COPY --from=builder /app/main /app/run.sh /opt/application
USER root
CMD /opt/application/run.sh
