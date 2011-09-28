{ stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, pkgconfig, gstreamer }:

let v = "2.3.1a"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/OpenCV-${v}.tar.bz2";
    sha256 = "0325s7pa2npcw2gc06pr6q5ik4xdyf08rvkfc0myn10w20lzb8m9";
  };

  buildInputs = [ gtk libjpeg libpng libtiff jasper ffmpeg gstreamer ];

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
