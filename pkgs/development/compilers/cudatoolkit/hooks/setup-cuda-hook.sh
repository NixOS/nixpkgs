# shellcheck shell=bash

echo Sourcing setup-cuda-hook >&2

extendCUDAToolkit_ROOT() {
    if [[ -f "$1/nix-support/include-in-cudatoolkit-root" ]] ; then
        addToSearchPathWithCustomDelimiter ";" CUDAToolkit_ROOT "$1"

        if [[ -d "$1/include" ]] ; then
            addToSearchPathWithCustomDelimiter ";" CUDAToolkit_INCLUDE_DIR "$1/include"
        fi
    fi
}

addEnvHooks "$targetOffset" extendCUDAToolkit_ROOT

setupCUDAToolkitCompilers() {
    echo Executing setupCUDAToolkitCompilers >&2

    if [[ -n "${dontSetupCUDAToolkitCompilers-}" ]] ; then
        return
    fi

    # Point NVCC at a compatible compiler

    # For CMake-based projects:
    # https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
    # https://cmake.org/cmake/help/latest/envvar/CUDAHOSTCXX.html
    # https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_HOST_COMPILER.html

    export cmakeFlags+=" -DCUDA_HOST_COMPILER=@ccFullPath@"
    export cmakeFlags+=" -DCMAKE_CUDA_HOST_COMPILER=@ccFullPath@"

    # For non-CMake projects:
    # We prepend --compiler-bindir to nvcc flags.
    # Downstream packages can override these, because NVCC
    # uses the last --compiler-bindir it gets on the command line.
    # FIXME: this results in "incompatible redefinition" warnings.
    # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
    if [ -z "${CUDAHOSTCXX-}" ]; then
      export CUDAHOSTCXX="@ccFullPath@";
    fi

    export NVCC_PREPEND_FLAGS+=" --compiler-bindir=@ccRoot@/bin"

    # NOTE: We set -Xfatbin=-compress-all, which reduces the size of the compiled
    #   binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
    #   the default set of CUDA capabilities we build can regularly cause this to occur (for
    #   example, with Magma).
    #
    # @SomeoneSerge: original comment was made by @ConnorBaker in .../cudatoolkit/common.nix
    if [[ -z "${dontCompressFatbin-}" ]]; then
        export NVCC_PREPEND_FLAGS+=" -Xfatbin=-compress-all"
    fi

    # CMake's enable_language(CUDA) runs a compiler test and it doesn't account for
    # CUDAToolkit_ROOT. We have to help it locate libcudart
    if [[ -z "${nvccDontPrependCudartFlags-}" ]] ; then
        export NVCC_APPEND_FLAGS+=" -L@cudartLib@/lib -L@cudartStatic@/lib -I@cudartInclude@/include"
    fi
}

setupCMakeCUDAToolkit_ROOT() {
    export cmakeFlags+=" -DCUDAToolkit_INCLUDE_DIR=$CUDAToolkit_INCLUDE_DIR -DCUDAToolkit_ROOT=$CUDAToolkit_ROOT"
}

postHooks+=(setupCUDAToolkitCompilers)
preConfigureHooks+=(setupCMakeCUDAToolkit_ROOT)
