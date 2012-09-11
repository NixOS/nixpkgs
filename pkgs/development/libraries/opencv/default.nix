{ stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, pkgconfig, gstreamer, xineLib, glib }:

let v = "2.4.2"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/OpenCV-${v}.tar.bz2";
    sha256 = "0a1c4ys78k670dsk1fapylpf8hwfyzy944r9jvwivqh33s0j6039";
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
