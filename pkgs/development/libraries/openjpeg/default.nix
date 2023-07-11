{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config
, libdeflate, libpng, libtiff, zlib, lcms2, jpylyzer
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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = "v${version}";
    sha256 = "sha256-/0o3Fl6/jx5zu854TCqMyOz/8mnEyEC9lpZ6ij/tbHc=";
  };

  outputs = [ "out" "dev" ];

  patches = [
    # modernise cmake files, also fixes them for multiple outputs
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/pull/1424.patch";
      sha256 = "sha256-CxVRt1u4HVOMUjWiZ2plmZC29t/zshCpSY+N4Wlrlvg=";
    })
    # fix cmake files cross compilation
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/commit/c6ceb84c221b5094f1e8a4c0c247dee3fb5074e8.patch";
      sha256 = "sha256-gBUtmO/7RwSWEl7rc8HGr8gNtvNFdhjEwm0Dd51p5O8=";
    })
  ];

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

  doCheck = (!stdenv.isAarch64 && !stdenv.hostPlatform.isPower64); # tests fail on aarch64-linux and powerpc64
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
