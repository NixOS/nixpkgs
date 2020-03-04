{ stdenv, fetchFromGitHub, cmake, pkgconfig
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
# Inherit generics
, branch, version, revision, sha256, patches ? [], extraFlags ? [], ...
}:

assert jpipServerSupport -> jpipLibSupport && curl != null && fcgi != null;
#assert opjViewerSupport -> (wxGTK != null);
assert (openjpegJarSupport || jpipLibSupport) -> jdk != null;

let
  inherit (stdenv.lib) optional optionals;
  mkFlag = optSet: flag: "-D${flag}=${if optSet then "ON" else "OFF"}";
in

stdenv.mkDerivation {
  pname = "openjpeg";
  inherit version;

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = revision;
    inherit sha256;
  };

  inherit patches;

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
  ] ++ extraFlags;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ ]
    ++ optionals jpipServerSupport [ curl fcgi ]
    #++ optional opjViewerSupport wxGTK
    ++ optional (openjpegJarSupport || jpipLibSupport) jdk;

  propagatedBuildInputs = [ libpng libtiff lcms2 ];

  doCheck = (testsSupport && !stdenv.isAarch64); # tests fail on aarch64-linux
  checkPhase = ''
    substituteInPlace ../tools/ctest_scripts/travis-ci.cmake \
      --replace "JPYLYZER_EXECUTABLE=" "JPYLYZER_EXECUTABLE=\"${jpylyzer}/bin/jpylyzer\" # "
    OPJ_SOURCE_DIR=.. ctest -S ../tools/ctest_scripts/travis-ci.cmake
  '';

  passthru = {
    incDir = "openjpeg-${branch}";
  };

  meta = with stdenv.lib; {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = http://www.openjpeg.org/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
