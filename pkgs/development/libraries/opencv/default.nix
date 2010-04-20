{ stdenv, fetchurl, cmake, gtk, glib, libjpeg, libpng, libtiff, jasper, ffmpeg, pkgconfig,
  xineLib, gstreamer }:

stdenv.mkDerivation rec {
  name = "opencv-2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/OpenCV-2.1.0.tar.bz2";
    sha256 = "0zrr24hr64gz35qb95nsvvbmdf89biglpy9z14y5kaxh5baiy1i6";
  };

  buildInputs = [ cmake gtk glib libjpeg libpng libtiff jasper ffmpeg pkgconfig
    xineLib gstreamer ];

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.willowgarage.com/;
    license = "BSD";
  };
}
