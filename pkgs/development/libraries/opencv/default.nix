{ lib, stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, fetchpatch, pkgconfig, gstreamer, xineLib, glib, python27, python27Packages, unzip
, zlib, enableBloat ? false }:

let v = "2.4.11"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/opencv-${v}.zip";
    sha256 = "1shz5g7ahvbb41gprxzvavllf235qhx0fpkjd7iwa3gv83ym46dg";
  };

  buildInputs =
    [ unzip libjpeg libpng libtiff ]
    ++ lib.optionals enableBloat [ gtk glib jasper ffmpeg xineLib gstreamer python27 python27Packages.numpy ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DZLIB_LIBRARY=${zlib}/lib/libz.so"
    "-DTIFF_LIBRARY=${libtiff}/lib/libtiff.so"
    "-DPNG_LIBRARY_RELEASE=${libpng}/lib/libpng.so"
    "-DJPEG_LIBRARY=${libjpeg}/lib/libjpeg.so"
    "-DJASPER_LIBRARY_RELEASE=${jasper}/lib/libjasper.so"
  ];

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric flosse];
    platforms = with stdenv.lib.platforms; linux;
  };
}
