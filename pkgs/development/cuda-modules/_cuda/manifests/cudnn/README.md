# cudnn

Link: <https://developer.download.nvidia.com/compute/cudnn/redist/>

Requirements: <https://docs.nvidia.com/deeplearning/cudnn/backend/v9.8.0/reference/support-matrix.html#gpu-cuda-toolkit-and-cuda-driver-requirements>

8.9.7 is the latest release from the 8.x series and supports everything but Jetson.
8.9.5 is the latest release from the 8.x series that supports Jetson.

9.20.0 is the latest release that supports linux-aarch64 (pre-Thor Jetson) with CUDA 12.
9.14.0 is the latest release with a linux-aarch64 (pre-Thor Jetson) build for CUDA 13, but NVIDIA provides no CUDA 13
toolkit for linux-aarch64; Jetson Orin uses linux-sbsa from CUDA 13.2.
