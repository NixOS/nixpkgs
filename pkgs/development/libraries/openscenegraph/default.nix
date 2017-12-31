{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, doxygen
, freetype, libjpeg, jasper, libxml2, zlib, gdal, curl, libX11, libpthreadstubs
, cairo, poppler, librsvg, libpng, libtiff, libXrandr, libXdmcp
, pcre, xineLib, boost
, withApps ? false
, withSDL ? false,  SDL
, withQt ? false,   qtbase
}:

stdenv.mkDerivation rec {
  name = "openscenegraph-${version}";
  version = "3.4.1";

  src = fetchFromGitHub rec {
    owner  = "openscenegraph";
    repo   = "OpenSceneGraph";
    rev    = "${repo}-${version}";
    sha256 = "1fbzg1ihjpxk6smlq80p3h3ggllbr16ihd2fxpfwzam8yr8yxip9";
  };

  # The Qt OpenGL module is deprecated and now part of Qt GUI
  postPatch = "substituteInPlace src/osgQt/CMakeLists.txt --replace OpenGL ''";

  nativeBuildInputs = [ cmake doxygen pkgconfig ];

  buildInputs = [
    freetype libjpeg jasper libxml2 zlib gdal curl
    cairo poppler librsvg libpng libtiff boost
    pcre xineLib
    libpthreadstubs libX11 libXdmcp libXrandr
  ] ++ lib.optional withSDL SDL
    ++ lib.optional withQt  qtbase;

  enableParallelBuilding = true;

  cmakeFlags = lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF";

  meta = with stdenv.lib; {
    description = "A 3D graphics toolkit";
    homepage    = http://www.openscenegraph.org/;
    license     = "OpenSceneGraph Public License - free LGPL-based license";
    maintainers = with maintainers; [ raskin ];
    platforms   = platforms.linux;
  };
}
