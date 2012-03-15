{ fetchurl, stdenv, pkgconfig, gst_plugins_base, bzip2, yasm
, useInternalFfmpeg ? false, ffmpeg ? null }:

stdenv.mkDerivation rec {
  name = "gst-ffmpeg-0.10.12";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-ffmpeg/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "0fyppl8q18g71jd2r0mbiqk8hhrdxq43dglma06mxyjb5c80fxxi";
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
