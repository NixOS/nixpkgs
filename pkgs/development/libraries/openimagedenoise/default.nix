{
  cmake,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  fetchzip,
  ispc,
  lib,
  python3,
  stdenv,
  tbb,
}:

stdenv.mkDerivation rec {
  pname = "openimagedenoise";
  version = "2.2.2";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/OpenImageDenoise/oidn/releases/download/v${version}/oidn-${version}.src.tar.gz";
    sha256 = "sha256-ZIrs4oEb+PzdMh2x2BUFXKyu/HBlFb3CJX24ciEHy3Q=";
  };

  patches = lib.optional cudaSupport ./cuda.patch;

  nativeBuildInputs = [
    cmake
    python3
    ispc
  ] ++ lib.optional cudaSupport cudaPackages.cuda_nvcc;

  buildInputs =
    [ tbb ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cccl
    ];

  cmakeFlags = [
    (lib.cmakeBool "OIDN_DEVICE_CUDA" cudaSupport)
    (lib.cmakeFeature "TBB_INCLUDE_DIR" "${tbb.dev}/include")
    (lib.cmakeFeature "TBB_ROOT" "${tbb}")
  ];

  meta = with lib; {
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
    changelog = "https://github.com/OpenImageDenoise/oidn/blob/v${version}/CHANGELOG.md";
  };
}
