{ stdenv, fetchurl, cmake, gtk, glib, libjpeg, libpng, libtiff, jasper, ffmpeg, pkgconfig,
  xineLib, gstreamer }:

stdenv.mkDerivation rec {
  name = "opencv-2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/OpenCV-2.0.0.tar.bz2";
    sha256 = "08h03qzawj6zwifrh8rq66y4cya1kxx9ixrbq7phlac79nbvjzf1";
  };

  buildInputs = [ cmake gtk glib libjpeg libpng libtiff jasper ffmpeg pkgconfig
    xineLib gstreamer ];

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.willowgarage.com/;
    license = "BSD";
  };
}
