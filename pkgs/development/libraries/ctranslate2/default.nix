{ lib
, stdenv
, fetchFromGitHub
, cmake
, darwin # Accelerate
, llvmPackages # openmp
, oneDNN
, openblas
, withMkl ? false, mkl
}:

let
  cmakeBool = b: if b then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  pname = "ctranslate2";
  version = "3.15.1";

  src = fetchFromGitHub {
    owner = "OpenNMT";
    repo = "CTranslate2";
    rev = "v${version}";
    hash = "sha256-lh4j53+LQj09tq3qiHrL2YrACzWY1V/HX8Ixnq0TTyY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # https://opennmt.net/CTranslate2/installation.html#build-options
    "-DWITH_DNNL=OFF" # requires oneDNN>=3.0
    "-DWITH_OPENBLAS=ON"
    "-DWITH_MKL=${cmakeBool withMkl}"
  ]
  ++ lib.optional stdenv.isDarwin "-DWITH_ACCELERATE=ON";

  buildInputs = [
    llvmPackages.openmp
    openblas
    oneDNN
  ] ++ lib.optional withMkl [
    mkl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Accelerate
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.CoreVideo
  ];

  meta = with lib; {
    description = "Fast inference engine for Transformer models";
    homepage = "https://github.com/OpenNMT/CTranslate2";
    changelog = "https://github.com/OpenNMT/CTranslate2/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
