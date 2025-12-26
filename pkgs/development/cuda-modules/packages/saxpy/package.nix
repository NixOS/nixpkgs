{
  backendStdenv,
  cmake,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  flags,
  lib,
  libcublas,
  saxpy,
}:
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "saxpy";
  version = "0-unstable-2023-07-11";

  src = ./src;

  nativeBuildInputs = [
    cmake
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cccl
    cuda_cudart
    libcublas
  ];

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
  ];

  passthru.gpuCheck = saxpy.overrideAttrs (_: {
    requiredSystemFeatures = [ "cuda" ];
    doInstallCheck = true;
    postInstallCheck = ''
      $out/bin/${saxpy.meta.mainProgram or (lib.getName saxpy)}
    '';
  });

  meta = {
    description = "Simple (Single-precision AX Plus Y) FindCUDAToolkit.cmake example for testing cross-compilation";
    license = lib.licenses.mit;
    teams = [ lib.teams.cuda ];
    mainProgram = "saxpy";
    platforms = lib.platforms.unix;
  };
})
