{ autoAddOpenGLRunpathHook
, backendStdenv
, cmake
, cuda_cccl ? null
, cuda_cudart ? null
, cudaFlags
, cuda_nvcc ? null
, cudatoolkit ? null
, lib
, libcublas ? null
, setupCudaHook
, stdenv
}:

backendStdenv.mkDerivation {
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./.;

  buildInputs = lib.optionals (cuda_cudart != null) [
    libcublas
    cuda_cudart
    cuda_cccl
  ] ++ lib.optionals (cuda_cudart == null) [
    cudatoolkit
  ];
  nativeBuildInputs = [
    cmake

    # Alternatively, we could remove the propagated hook from cuda_nvcc and add
    # directly:
    # setupCudaHook
    autoAddOpenGLRunpathHook
  ] ++ lib.optionals (cuda_nvcc != null) [
    cuda_nvcc
  ] ++ lib.optionals (cuda_nvcc == null) [
    cudatoolkit
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
