{ autoAddOpenGLRunpathHook
, backendStdenv
, cmake
, cuda_cccl
, cuda_cudart
, cudaFlags
, cuda_nvcc
, lib
, libcublas
, setupCudaHook
, stdenv
}:

backendStdenv.mkDerivation {
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./.;

  buildInputs = [
    libcublas
    cuda_cudart
    cuda_cccl
  ];
  nativeBuildInputs = [
    cmake

    # NOTE: this needs to be pkgs.buildPackages.cudaPackages_XX_Y.cuda_nvcc for
    # cross-compilation to work. This should work automatically once we move to
    # spliced scopes. Delete this comment once that happens
    cuda_nvcc

    # Alternatively, we could remove the propagated hook from cuda_nvcc and add
    # directly:
    # setupCudaHook
    autoAddOpenGLRunpathHook
  ];

  cmakeFlags = [
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    "-DCMAKE_CUDA_ARCHITECTURES=${with cudaFlags; builtins.concatStringsSep ";" (map dropDot cudaCapabilities)}"
  ];

  meta = {
    description = "A simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    maintainers = lib.teams.cuda.members;
    platforms = lib.platforms.unix;
  };
}
