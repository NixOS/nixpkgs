{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  config,
  symlinkJoin,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? null,
  rocmSupport ? config.rocmSupport,
  rocmPackages,
}:

assert cudaSupport -> cudaPackages != null;

let
  rocm-sdk = symlinkJoin {
    name = "rocm-merged";
    paths = with rocmPackages; [
      clr
      rocm-comgr
      rocm-device-libs
      rocm-runtime
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "umpire";
  version = "2026.07.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "umpire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-68gqyP+VCX9EkFpxpf8hZBK158jWX2wpNDIm6J2+fnI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals rocmSupport [
    rocm-sdk
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
      "-DROCM_ROOT_DIR=${rocm-sdk}"
    ];

  passthru = { inherit rocmSupport; };

  meta = {
    description = "Application-focused API for memory management on NUMA & GPU architectures";
    homepage = "https://github.com/LLNL/Umpire";
    maintainers = with lib.maintainers; [ sheepforce ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
