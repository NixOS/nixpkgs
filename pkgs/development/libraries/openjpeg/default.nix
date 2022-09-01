{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config
, libpng, libtiff, lcms2, jpylyzer
, mj2Support ? true # MJ2 executables
, jpwlLibSupport ? true # JPWL library & executables
, jpipLibSupport ? false # JPIP library & executables
, jpipServerSupport ? false, curl ? null, fcgi ? null # JPIP Server
#, opjViewerSupport ? false, wxGTK ? null # OPJViewer executable
, openjpegJarSupport ? false # Openjpeg jar (Java)
, jp3dSupport ? true # # JP3D comp
, thirdPartySupport ? false # Third party libraries - OFF: only build when found, ON: always build
, testsSupport ? true
, jdk ? null
}:

assert jpipServerSupport -> jpipLibSupport && curl != null && fcgi != null;
#assert opjViewerSupport -> (wxGTK != null);
assert (openjpegJarSupport || jpipLibSupport) -> jdk != null;

let
  inherit (lib) optional optionals;
  mkFlag = optSet: flag: "-D${flag}=${lib.boolToCMakeString optSet}";
in

stdenv.mkDerivation rec {
  pname = "openjpeg";
  version = "2.4.0"; # don't forget to change passthru.incDir

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = "v${version}";
    sha256 = "143dvy5g6v6129lzvl0r8mrgva2fppkn0zl099qmi9yi9l9h7yyf";
  };

  patches = [
    ./fix-cmake-config-includedir.patch
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/uclouvain/openjpeg/pull/1321.patch";
      sha256 = "1cjpr76nf9g65nqkfnxnjzi3bv7ifbxpc74kxxibh58pzjlp6al8";
    })
  ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_NAME_DIR=\${CMAKE_INSTALL_PREFIX}/lib"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_CODEC=ON"
    (mkFlag mj2Support "BUILD_MJ2")
    (mkFlag jpwlLibSupport "BUILD_JPWL")
    (mkFlag jpipLibSupport "BUILD_JPIP")
    (mkFlag jpipServerSupport "BUILD_JPIP_SERVER")
    #(mkFlag opjViewerSupport "BUILD_VIEWER")
    "-DBUILD_VIEWER=OFF"
    (mkFlag openjpegJarSupport "BUILD_JAVA")
    (mkFlag jp3dSupport "BUILD_JP3D")
    (mkFlag thirdPartySupport "BUILD_THIRDPARTY")
    (mkFlag testsSupport "BUILD_TESTING")
    "-DOPENJPEG_INSTALL_INCLUDE_DIR=${placeholder "dev"}/include/${passthru.incDir}"
    "-DOPENJPEG_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/${passthru.incDir}"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ ]
    ++ optionals jpipServerSupport [ curl fcgi ]
    #++ optional opjViewerSupport wxGTK
    ++ optional (openjpegJarSupport || jpipLibSupport) jdk;

  propagatedBuildInputs = [ libpng libtiff lcms2 ];

  doCheck = (testsSupport && !stdenv.isAarch64 && !stdenv.hostPlatform.isPower64); # tests fail on aarch64-linux and powerpc64
  checkPhase = ''
    substituteInPlace ../tools/ctest_scripts/travis-ci.cmake \
      --replace "JPYLYZER_EXECUTABLE=" "JPYLYZER_EXECUTABLE=\"${jpylyzer}/bin/jpylyzer\" # "
    OPJ_SOURCE_DIR=.. ctest -S ../tools/ctest_scripts/travis-ci.cmake
  '';

  passthru = {
    incDir = "openjpeg-2.4";
  };

  meta = with lib; {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = "https://www.openjpeg.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
