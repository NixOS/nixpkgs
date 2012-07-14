{ stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, pkgconfig, gstreamer, xineLib, glib }:

let v = "2.4.1"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/OpenCV-${v}.tar.bz2";
    sha256 = "1wxijbz1jfsg4695fls83825ppiacxfn5x07al0qkkx5rm7spdi9";
  };

  buildInputs = [ gtk glib libjpeg libpng libtiff jasper ffmpeg xineLib gstreamer ];

  buildNativeInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.willowgarage.com/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
