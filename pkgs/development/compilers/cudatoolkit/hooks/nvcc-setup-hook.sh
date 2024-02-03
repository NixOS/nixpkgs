# shellcheck shell=bash

# CMake's enable_language(CUDA) runs a compiler test and it doesn't account for
# CUDAToolkit_ROOT. We have to help it locate libcudart
export NVCC_APPEND_FLAGS+=" -L@cudartLib@/lib -L@cudartStatic@/lib -I@cudartInclude@/include"
