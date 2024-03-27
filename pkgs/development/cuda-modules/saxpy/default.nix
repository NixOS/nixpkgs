{
  cmake,
  cudaPackages,
  lib,
}:
let
  inherit (cudaPackages)
    autoAddDriverRunpath
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudaAtLeast
    cudaOlder
    cudatoolkit
    flags
    libcublas
    ;
in
backendStdenv.mkDerivation {
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./.;

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      autoAddDriverRunpath
    ]
    ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [ cuda_nvcc ];

  # buildInputs =
  #   lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
  #   ++ lib.optionals (cudaAtLeast "11.4") [
  #     cuda_cudart
  #     libcublas
  #     # libcublas.dev
  #     # libcublas.lib
  #   ]
  #   ++ lib.optionals (cudaAtLeast "12.0") [ cuda_cccl ];

  # TODO: CMake tells us CUDA_HOST_COMPILER is an unused variable; CMAKE_CUDA_HOST_COMPILER is used and we can set it.
  # TODO: CMake tells us CUDAToolkit_INCLUDE_DIR is an unused variable; CUDAToolkit_INCLUDE_DIRS is used and we can set it.
  # TODO: What is the difference between CUDA_CUDA_COMPILER and CMAKE_CUDA_HOST_COMPILER, or CUDACXX and CUDAHOSTCXX?
  # TODO: The CUDA compiler source identification process used by CMake requires building and running a test program. This is not possible in a cross-compilation environment. We can use CMAKE_CUDA_FLAGS_INIT to get around it.
  # TODO: Why aren't any of these correctly configured by the environment?
  # TODO: See whether CUDAToolkit_INCLUDE_DIR etc is necessary, or just the LIBRARY_PATH and LD_LIBRARY_PATH.
  # TODO: /nix/store/j2y057vz3i19yh4zjsan1s3q256q15rd-binutils-2.41/bin/ld: /nix/store/gh1azxmwdisz1q92h1hw20w9l72gwza7-libcublas-aarch64-unknown-linux-gnu-12.2.5.6-lib/lib/libcublas.so: error adding symbols: file in wrong format
  preConfigure =
    let
      inherit (backendStdenv.__spliced.buildHost) cc;
      ccFullPath = "${cc}/bin/${cc.targetPrefix}c++";
      ccRoot = "${cc}";
      nvccBuildHost = cuda_nvcc.__spliced.buildHost;
      cudartBuildHost = cuda_cudart.__spliced.buildHost;

      cudartHostTarget = cuda_cudart.__spliced.hostTarget;
      ccclHostTarget = cuda_cccl.__spliced.hostTarget;
      libcublasHostTarget = libcublas.__spliced.hostTarget;
    in
    # Working (until linker error)
    # export NVCC_PREPEND_FLAGS+=" -I${cudartHostTarget}/include -I${ccclHostTarget}/include -L${cudartHostTarget}/lib -L${ccclHostTarget}/lib"
    # export LIBRARY_PATH+="${cudartHostTarget}/lib"
    # export LD_LIBRARY_PATH+="${cudartHostTarget}/lib"
    # export CPATH="$CUDAToolkit_INCLUDE_DIRS"
    #
    # Ripped from setup-cuda-hook::setupCUDAToolkitCompilers, added logging
    ''
      # Name function never needs to have return value checked.
      # shellcheck disable=SC2155

      for path in "${cudartHostTarget}" "${ccclHostTarget}" "${libcublasHostTarget}" "${nvccBuildHost}"; do
        if [[ -d "$path" ]]; then
          echo "Adding $path to CUDAToolkit search path"
          addToSearchPathWithCustomDelimiter ";" CUDAToolkit_ROOT "$path"
          echo "CUDAToolkit_ROOT is now $CUDAToolkit_ROOT"
        else
          echo "Skipping $path as it is not a directory"
        fi

        if [[ -d "$path/include" ]]; then
          echo "Adding $path/include to CUDAToolkit search path"
          addToSearchPathWithCustomDelimiter ";" CUDAToolkit_INCLUDE_DIRS "$path/include"
          echo "CUDAToolkit_INCLUDE_DIRS is now $CUDAToolkit_INCLUDE_DIRS"
        else
          echo "Skipping $path/include as it is not a directory"
        fi
      done

      export cmakeFlagsArray+=(
        -DCUDAToolkit_INCLUDE_DIRS="''${CUDAToolkit_INCLUDE_DIRS:-}"
        -DCUDAToolkit_ROOT="''${CUDAToolkit_ROOT:-}"
      )
    ''
    # Try to export the include dirs to CPATH, replacing the semicolons with colons
    + ''
      export CPATH="''${CUDAToolkit_INCLUDE_DIRS//;/:}"
      echo "CPATH is now $CPATH"
    ''
    # Ripped from setup-cuda-hook::setupCUDAToolkitCompilers
    + ''
      # Point NVCC at a compatible compiler

      # For CMake-based projects:
      # https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
      # https://cmake.org/cmake/help/latest/envvar/CUDAHOSTCXX.html
      # https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_HOST_COMPILER.html

      export cmakeFlagsArray+=(
        -DCMAKE_CUDA_HOST_COMPILER="${ccFullPath}"
      )

      # For non-CMake projects:
      # We prepend --compiler-bindir to nvcc flags.
      # Downstream packages can override these, because NVCC
      # uses the last --compiler-bindir it gets on the command line.
      # FIXME: this results in "incompatible redefinition" warnings.
      # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
      export CUDAHOSTCXX="${ccFullPath}"

      export NVCC_PREPEND_FLAGS+=" --compiler-bindir=${ccRoot}/bin"

      # NOTE: We set -Xfatbin=-compress-all, which reduces the size of the compiled
      # binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
      # the default set of CUDA capabilities we build can regularly cause this to occur (for
      # example, with Magma).
      #
      # @SomeoneSerge: original comment was made by @ConnorBaker in .../cudatoolkit/common.nix
      export NVCC_PREPEND_FLAGS+=" -Xfatbin=-compress-all"
    ''
    # Try to get around compiler initialization via CMAKE_CUDA_FLAGS_INIT
    + ''
      export cmakeFlagsArray+=(
        -DCMAKE_CUDA_FLAGS_INIT="-L${cudartBuildHost}/lib -I${cudartBuildHost}/include"
      )
    '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
      with flags; lib.concatStringsSep ";" (lib.lists.map dropDot cudaCapabilities)
    ))
  ];

  meta = rec {
    description = "A simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    maintainers = lib.teams.cuda.members;
    platforms = lib.platforms.unix;
    badPlatforms = lib.optionals (flags.isJetsonBuild && cudaOlder "11.4") platforms;
  };
}
