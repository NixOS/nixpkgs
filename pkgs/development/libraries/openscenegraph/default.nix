{ stdenv, lib, fetchurl, cmake, pkgconfig, doxygen, unzip
, freetype, libjpeg, jasper, libxml2, zlib, gdal, curl, libX11
, cairo, poppler, librsvg, libpng, libtiff, libXrandr
, xineLib, boost
, withApps ? false
, withSDL ? false, SDL
, withQt4 ? false, qt4
}:

stdenv.mkDerivation rec {
  name = "openscenegraph-${version}";
  version = "3.2.3";

  src = fetchurl {
    url = "http://trac.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-${version}.zip";
    sha256 = "0gic1hy7fhs27ipbsa5862q120a9y4bx176nfaw2brcjp522zvb9";
  };

  nativeBuildInputs = [ pkgconfig cmake doxygen unzip ];

  buildInputs = [
    freetype libjpeg jasper libxml2 zlib gdal curl libX11
    cairo poppler librsvg libpng libtiff libXrandr boost
    xineLib
  ] ++ lib.optional withSDL SDL
    ++ lib.optional withQt4 qt4;

  enableParallelBuilding = true;

  cmakeFlags = lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF";

  meta = with stdenv.lib; {
    description = "A 3D graphics toolkit";
    homepage = http://www.openscenegraph.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}
