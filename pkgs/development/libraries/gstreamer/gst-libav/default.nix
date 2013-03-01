{ fetchurl, stdenv, pkgconfig, gst_plugins_base, bzip2, yasm }:

stdenv.mkDerivation rec {
  name = "gst-libav-1.0.5";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-libav/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1m9jzga9ahml3dnfm7syz6mglmysqpbkkyr48kka9cwna1kbxy5f";
  };

  buildInputs =
    [ pkgconfig bzip2 gst_plugins_base yasm ];

  enableParallelBuilding = true; 

  meta = {
    homepage = "http://gstreamer.freedesktop.org/releases/gst-libav";
    description = "GStreamer's plug-in using FFmpeg";
    license = "GPLv2+";
  };
}
