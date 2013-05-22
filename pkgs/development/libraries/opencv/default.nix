{ stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, pkgconfig, gstreamer, xineLib, glib, python27, python27Packages }:

let v = "2.4.5"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/opencv-${v}.tar.gz";
    sha256 = "14k2w07jcchp11c9v6p5x49h3h1zmg2m9brm2sypz5sp9g7yw2yk";
  };

  buildInputs = [ gtk glib libjpeg libpng libtiff jasper ffmpeg xineLib gstreamer
    python27 python27Packages.numpy ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.willowgarage.com/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
