{ stdenv, fetchurl, cmake, gtk, glib, libjpeg, libpng, libtiff, jasper, ffmpeg, pkgconfig,
  xineLib, gstreamer }:

stdenv.mkDerivation rec {
  name = "opencv-2.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/OpenCV-2.3.0.tar.bz2";
    sha256 = "02wl56a87if84brrhd4wq59linyhbxx30ykh4cjwzw37yw7zzgxw";
  };

  buildInputs = [ cmake gtk glib libjpeg libpng libtiff jasper ffmpeg pkgconfig
    xineLib gstreamer ];

  enableParallelBuilding = true;

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.willowgarage.com/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
