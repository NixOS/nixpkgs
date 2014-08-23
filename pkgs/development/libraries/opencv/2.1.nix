{ stdenv, fetchurl, cmake, gtk, glib, libjpeg, libpng, libtiff, jasper, ffmpeg, pkgconfig,
  xineLib, gstreamer }:

stdenv.mkDerivation rec {
  name = "opencv-2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencvlibrary/OpenCV-2.1.0.tar.bz2";
    sha256 = "26061fd52ab0ab593c093ff94b5f5c09b956d7deda96b47019ff11932111397f";
  };

  # The order is important; libpng should go before X libs, because they
  # propagate the libpng 1.5 (and opencv wants libpng 1.2)
  buildInputs = [ cmake libpng gtk glib libjpeg libtiff jasper ffmpeg pkgconfig
    xineLib gstreamer ];

  enableParallelBuilding = true;

  patchPhase = ''
    sed -i 's/ptrdiff_t/std::ptrdiff_t/' include/opencv/*
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D__STDC_CONSTANT_MACROS "
  '';

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.willowgarage.com/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = true;
  };
}
