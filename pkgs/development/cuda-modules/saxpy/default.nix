{
  autoAddDriverRunpath,
  cmake,
  cudaPackages,
  lib,
}:
let
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudaAtLeast
    cudaOlder
    cudatoolkit
    flags
    libcublas
    setupCudaHook
    ;
  inherit (lib) getDev getLib getOutput;
in
backendStdenv.mkDerivation {
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./.;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      autoAddDriverRunpath
    ]
    ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [ cuda_nvcc ];

  buildInputs =
    lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [
      (getDev libcublas)
      (getLib libcublas)
      (getOutput "static" libcublas)
      cuda_cudart
    ]
    ++ lib.optionals (cudaAtLeast "12.0") [ cuda_cccl ];

  cmakeFlagsArray = [
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
  ];

  meta = rec {
    description = "A simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    maintainers = lib.teams.cuda.members;
    platforms = lib.platforms.unix;
    badPlatforms = lib.optionals (flags.isJetsonBuild && cudaOlder "11.4") platforms;
  };
}
