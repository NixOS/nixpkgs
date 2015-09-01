{ lib, stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, fetchpatch, pkgconfig, gstreamer, xineLib, glib, python27, python27Packages, unzip
, enableBloat ? false }:

let v = "3.0.0"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "https://github.com/Itseez/opencv/archive/${v}.zip";
    sha256 = "00dh7wvgkflz22liqd10fma8m3395lb3l3rgawnn5wlnz6i4w287";
  };

  buildInputs =
    [ unzip libjpeg libpng libtiff ]
    ++ lib.optionals enableBloat [ gtk glib jasper ffmpeg xineLib gstreamer python27 python27Packages.numpy ];

  nativeBuildInputs = [ cmake pkgconfig ];

  # TODO: Pre-download IPP so that OpenCV doesn't try to download it itself
  # (which fails).
  cmakeFlags = [ "-DWITH_IPP=OFF" ];

  enableParallelBuilding = true;

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric flosse];
    platforms = with stdenv.lib.platforms; linux;
  };
}
