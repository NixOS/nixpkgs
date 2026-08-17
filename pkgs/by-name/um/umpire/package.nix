{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? null,
  rocmSupport ? config.rocmSupport,
  rocmPackages,
}:

assert cudaSupport -> cudaPackages != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "umpire";
  version = "2025.12.0";

  strictDeps = true;
  __structuredAttrs = true;

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
  ]
  ++ lib.optionals rocmSupport [
    rocmPackages.clr
  ];

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
      cuda_cudart
    ]
  );

  cmakeFlags =
    lib.optionals cudaSupport [
      "-DENABLE_CUDA=ON"
      (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    ]
    ++ lib.optionals rocmSupport [
      "-DENABLE_HIP=ON"
    ];

  passthru = { inherit rocmSupport; };

  meta = {
    description = "Application-focused API for memory management on NUMA & GPU architectures";
    homepage = "https://github.com/LLNL/Umpire";
    maintainers = with lib.maintainers; [ sheepforce ];
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.linux;
  };
})
