{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? null,
}:

assert cudaSupport -> cudaPackages != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "umpire";
  version = "2025.12.0";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "umpire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9lGI5SKpDIIzZvsG/yKopfXS1PuHOQB9bwSuML2Xh/8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cudatoolkit
      cuda_cudart
    ]
  );

  cmakeFlags = lib.optionals cudaSupport [
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
    "-DENABLE_CUDA=ON"
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  meta = {
    description = "Application-focused API for memory management on NUMA & GPU architectures";
    homepage = "https://github.com/LLNL/Umpire";
    maintainers = with lib.maintainers; [ sheepforce ];
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.linux;
  };
})
