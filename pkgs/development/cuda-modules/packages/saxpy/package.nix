{
  autoAddDriverRunpath,
  cmake,
  cudaPackages,
  lib,
  saxpy,
}:
let
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudaAtLeast
    flags
    libcublas
    ;
  inherit (lib) getDev getLib getOutput;
in
backendStdenv.mkDerivation {
  pname = "saxpy";
  version = "unstable-2023-07-11";

  src = ./src;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    autoAddDriverRunpath
    cuda_nvcc
  ];

  buildInputs = [
    (getDev libcublas)
    (getLib libcublas)
    (getOutput "static" libcublas)
    cuda_cudart
    cuda_cccl
  ];

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
    (lib.cmakeBool "CMAKE_SKIP_INSTALL_RPATH" false)
    (lib.cmakeBool "CMAKE_SKIP_RPATH" false)
    (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)
    (lib.cmakeFeature "CMAKE_INSTALL_RPATH" (
      lib.makeLibraryPath [
        (getLib libcublas)
        cuda_cudart
      ]
    ))
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
}
