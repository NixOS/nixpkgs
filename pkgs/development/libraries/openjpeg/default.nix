{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, libdeflate, libpng, libtiff, zlib, lcms2, jpylyzer
, jpipLibSupport ? false # JPIP library & executables
, jpipServerSupport ? false, curl, fcgi # JPIP Server
, opjViewerSupport ? false, wxGTK # OPJViewer executable
, openjpegJarSupport ? false # Openjpeg jar (Java)
, jdk
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

  cmakeFlags = [
    "-DCMAKE_INSTALL_NAME_DIR=\${CMAKE_INSTALL_PREFIX}/lib"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_CODEC=ON"
    "-DBUILD_THIRDPARTY=OFF"
    (mkFlag jpipLibSupport "BUILD_JPIP")
    (mkFlag jpipServerSupport "BUILD_JPIP_SERVER")
    (mkFlag opjViewerSupport "BUILD_VIEWER")
    (mkFlag openjpegJarSupport "BUILD_JAVA")
    (mkFlag doCheck "BUILD_TESTING")
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libdeflate libpng libtiff zlib lcms2 ]
    ++ lib.optionals jpipServerSupport [ curl fcgi ]
    ++ lib.optional opjViewerSupport wxGTK
    ++ lib.optional (openjpegJarSupport || jpipLibSupport) jdk;

  doCheck = (!stdenv.isAarch64 && !stdenv.hostPlatform.isPower64); # tests fail on aarch64-linux and powerpc64

  checkPhase = ''
    substituteInPlace ../tools/ctest_scripts/travis-ci.cmake \
      --replace "JPYLYZER_EXECUTABLE=" "JPYLYZER_EXECUTABLE=\"${jpylyzer}/bin/jpylyzer\" # "
    OPJ_SOURCE_DIR=.. ctest -S ../tools/ctest_scripts/travis-ci.cmake
  '';

  passthru = {
    incDir = "openjpeg-${lib.versions.majorMinor version}";
  };

  meta = with lib; {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = "https://www.openjpeg.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
    # opj viewer fails to compile with lots of errors, jar requires openjpeg library already compiled and installed
    broken = (opjViewerSupport || openjpegJarSupport);
  };
}
