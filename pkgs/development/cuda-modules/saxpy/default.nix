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
    cudatoolkit
    cudaVersion
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

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      autoAddDriverRunpath
    ]
    ++ lib.optionals (lib.versionOlder cudaVersion "11.4") [cudatoolkit]
    ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [cuda_nvcc];

  buildInputs =
    lib.optionals (lib.versionOlder cudaVersion "11.4") [cudatoolkit]
    ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [
      (getDev libcublas)
      (getLib libcublas)
      (getOutput "static" libcublas)
      cuda_cudart
    ]
    ++ lib.optionals (lib.versionAtLeast cudaVersion "12.0") [cuda_cccl];

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
      with flags; lib.concatStringsSep ";" (lib.lists.map dropDot cudaCapabilities)
    ))
  ];

  meta = rec {
    description = "A simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    maintainers = lib.teams.cuda.members;
    platforms = lib.platforms.unix;
    badPlatforms = lib.optionals flags.isJetsonBuild platforms;
  };
}
