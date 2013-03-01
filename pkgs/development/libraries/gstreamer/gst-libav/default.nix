{ fetchurl, stdenv, pkgconfig, gst_plugins_base, bzip2, yasm
, useInternalFfmpeg ? false, ffmpeg ? null }:

stdenv.mkDerivation rec {
  name = "gst-libav-1.0.5";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-libav/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1m9jzga9ahml3dnfm7syz6mglmysqpbkkyr48kka9cwna1kbxy5f";
  };

  # Upstream strongly recommends against using --with-system-ffmpeg,
  # but we do it anyway because we're so hardcore (and we don't want
  # multiple copies of ffmpeg).
  configureFlags = stdenv.lib.optionalString (!useInternalFfmpeg) "--with-system-ffmpeg";

  buildInputs =
    [ pkgconfig bzip2 gst_plugins_base ]
    ++ (if useInternalFfmpeg then [ yasm ] else [ ffmpeg ]);

  meta = {
    homepage = "http://gstreamer.freedesktop.org/releases/gst-ffmpeg";
    description = "GStreamer's plug-in using FFmpeg";
    license = "GPLv2+";
  };
}
