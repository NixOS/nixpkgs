{ stdenv, fetchurl, cmake, pkgconfig
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
, branch, sha256, version, ...
}:

assert jpipServerSupport -> jpipLibSupport && curl != null && fcgi != null;
#assert opjViewerSupport -> (wxGTK != null);
assert (openjpegJarSupport || jpipLibSupport) -> jdk != null;

let
  inherit (stdenv.lib) optional optionals;
  mkFlag = optSet: flag: "-D${flag}=${if optSet then "ON" else "OFF"}";
in

stdenv.mkDerivation rec {
  name = "openjpeg-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/openjpeg.mirror/${version}/openjpeg-${version}.tar.gz";
    inherit sha256;
  };

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
  ];

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
