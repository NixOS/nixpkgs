{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libpng, libtiff, lcms2
, mj2Support ? true # MJ2 executables
, jpwlLibSupport ? true # JPWL library & executables
, jpipLibSupport ? false # JPIP library & executables
, jpipServerSupport ? false, curl ? null, fcgi ? null # JPIP Server
#, opjViewerSupport ? false, wxGTK ? null # OPJViewer executable
, openjpegJarSupport ? false # Openjpeg jar (Java)
, jp3dSupport ? true # # JP3D comp
, thirdPartySupport ? false # Third party libraries - OFF: only build when found, ON: always build
, testsSupport ? false
, jdk ? null
# Inherit generics
, branch, version, revision, sha256, patches ? [], ...
}:

assert jpipServerSupport -> jpipLibSupport && curl != null && fcgi != null;
#assert opjViewerSupport -> (wxGTK != null);
assert (openjpegJarSupport || jpipLibSupport) -> jdk != null;

let
  inherit (stdenv.lib) optional optionals;
in

stdenv.mkDerivation rec {
  name = "openjpeg-${version}";

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = revision;
    inherit sha256;
  };

  inherit patches;

  outputs = [ "out" "dev" ];

  cmakeFlags = {
    CMAKE_INSTALL_NAME_DIR = "$CMAKE_INSTALL_PREFIX/lib";
    BUILD_SHARED_LIBS = true;
    BUILD_CODEC = true;
    BUILD_MJ2 = mj2Support;
    BUILD_JPWL = jpwlLibSupport;
    BUILD_JPIP = jpipLibSupport;
    BUILD_JPIP_SERVER = jpipServerSupport;
    BUILD_VIEWER = false;
    BUILD_JAVA = openjpegJarSupport;
    BUILD_JP3D = jp3dSupport;
    BUILD_THIRDPARTY = thirdPartySupport;
    BUILD_TESTING = testsSupport;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ ]
    ++ optionals jpipServerSupport [ curl fcgi ]
    #++ optional opjViewerSupport wxGTK
    ++ optional (openjpegJarSupport || jpipLibSupport) jdk;

  propagatedBuildInputs = [ libpng libtiff lcms2 ];

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
