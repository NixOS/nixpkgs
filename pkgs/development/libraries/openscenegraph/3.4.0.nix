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
  version = "3.4.0";

  src = fetchurl {
    url = "http://trac.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-${version}.zip";
    sha256 = "03h4wfqqk7rf3mpz0sa99gy715cwpala7964z2npd8jxfn27swjw";
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
