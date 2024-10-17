{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, libpng, libtiff, zlib, lcms2, jpylyzer
, jpipLibSupport ? false # JPIP library & executables
, jpipServerSupport ? false, curl, fcgi # JPIP Server
, jdk
, poppler
}:

let
  mkFlag = optSet: flag: "-D${flag}=${if optSet then "ON" else "OFF"}";
in

stdenv.mkDerivation rec {
  pname = "openjpeg";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = "v${version}";
    hash = "sha256-mQ9B3MJY2/bg0yY/7jUJrAXM6ozAHT5fmwES5Q1SGxw=";
  };

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_NAME_DIR=\${CMAKE_INSTALL_PREFIX}/lib"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_CODEC=ON"
    "-DBUILD_THIRDPARTY=OFF"
    (mkFlag jpipLibSupport "BUILD_JPIP")
    (mkFlag jpipServerSupport "BUILD_JPIP_SERVER")
    "-DBUILD_VIEWER=OFF"
    "-DBUILD_JAVA=OFF"
    (mkFlag doCheck "BUILD_TESTING")
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libpng libtiff zlib lcms2 ]
    ++ lib.optionals jpipServerSupport [ curl fcgi ]
    ++ lib.optional (jpipLibSupport) jdk;

  doCheck = (!stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isPower64); # tests fail on aarch64-linux and powerpc64
  nativeCheckInputs = [ jpylyzer ];
  checkPhase = ''
    substituteInPlace ../tools/ctest_scripts/travis-ci.cmake \
      --replace "JPYLYZER_EXECUTABLE=" "JPYLYZER_EXECUTABLE=\"$(command -v jpylyzer)\" # "
    OPJ_SOURCE_DIR=.. ctest -S ../tools/ctest_scripts/travis-ci.cmake
  '';

  passthru = {
    incDir = "openjpeg-${lib.versions.majorMinor version}";
    tests = {
      inherit poppler;
    };
  };

  meta = with lib; {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = "https://www.openjpeg.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
    changelog = "https://github.com/uclouvain/openjpeg/blob/v${version}/CHANGELOG.md";
  };
}
