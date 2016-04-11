{ stdenv, fetchurl, cmake, giflib, libjpeg, libtiff, lib3ds, freetype
, libpng, coin3d, jasper, gdal_1_11, xproto, libX11, libXmu
, freeglut, mesa, doxygen, ffmpeg, xineLib, unzip, zlib, openal
, libxml2, curl, a52dec, faad2, gdk_pixbuf, pkgconfig, kbproto, SDL
, qt4, poppler, librsvg, gtk }:

stdenv.mkDerivation rec {
  name = "openscenegraph-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "http://trac.openscenegraph.org/downloads/developer_releases/${name}.zip";
    sha256 = "0v9y1gxb16y0mj994jd0mhcz32flhv2r6kc01xdqb4817lk75bnr";
  };

  buildInputs = [
    cmake giflib libjpeg libtiff lib3ds freetype libpng coin3d jasper
    gdal_1_11 xproto libX11 libXmu freeglut mesa doxygen ffmpeg
    xineLib unzip zlib openal libxml2 curl a52dec faad2 gdk_pixbuf
    pkgconfig kbproto SDL qt4 poppler librsvg gtk
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DMATH_LIBRARY="
    "-DCMAKE_C_FLAGS=-D__STDC_CONSTANT_MACROS=1"
    "-DCMAKE_CXX_FLAGS=-D__STDC_CONSTANT_MACROS=1"
  ];

  meta = with stdenv.lib; {
    description = "A 3D graphics toolkit";
    homepage = http://www.openscenegraph.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}
