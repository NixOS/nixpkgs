{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libpng
, libjpeg
, libwebp
, blas
, lapack
, config
, guiSupport ? false
, libX11
, sse4Support ? stdenv.hostPlatform.sse4_1Support
, avxSupport ? stdenv.hostPlatform.avxSupport
, cudaSupport ? config.cudaSupport
, cudaPackages
}@inputs:
(if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv).mkDerivation rec {
  pname = "dlib";
  version = "19.24.4";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev = "v${version}";
    sha256 = "sha256-1A/9u+ThtUtmmSwnFSn8S65Yavucl2X+o3bNYgew0Oc=";
  };

  strictDeps = true;

  postPatch = ''
    rm -rf dlib/external
  '';

  cmakeFlags = [
    (lib.cmakeBool "USE_SSE4_INSTRUCTIONS" sse4Support)
    (lib.cmakeBool "USE_AVX_INSTRUCTIONS" avxSupport)
    (lib.cmakeBool "DLIB_USE_CUDA" cudaSupport)
  ] ++ lib.optionals cudaSupport [
    (
      lib.cmakeFeature
      "DLIB_USE_CUDA_COMPUTE_CAPABILITIES"
      (lib.replaceStrings [";"] [","] cudaPackages.cudaFlags.cmakeCudaArchitecturesString)
    )
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_nvcc
  ]);

  buildInputs = [
    libpng
    libjpeg
    libwebp
    blas
    lapack
  ]
  ++ lib.optionals guiSupport [ libX11 ]
  ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cccl
    cuda_cudart
    cudnn
    libcublas
    libcurand
    libcusolver
  ]);

  passthru = {
    inherit
      cudaSupport cudaPackages
      sse4Support avxSupport;
  };

  meta = with lib; {
    description = "General purpose cross-platform C++ machine learning library";
    homepage = "http://www.dlib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ];
    platforms = platforms.unix;
  };
}
