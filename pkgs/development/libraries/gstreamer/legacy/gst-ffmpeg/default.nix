{ fetchurl, stdenv, pkgconfig, gst-plugins-base, bzip2, yasm, orc
, useInternalFfmpeg ? false, ffmpeg ? null }:

stdenv.mkDerivation rec {
  name = "gst-ffmpeg-0.10.13";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-ffmpeg/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "0qmvgwcfybci78sd73mhvm4bsb7l0xsk9yljrgik80g011ds1z3n";
  };

  # Upstream strongly recommends against using --with-system-ffmpeg,
  # but we do it anyway because we're so hardcore (and we don't want
  # multiple copies of ffmpeg).
  configureFlags = stdenv.lib.optionalString (!useInternalFfmpeg) "--with-system-ffmpeg";

  buildInputs =
    [ pkgconfig bzip2 gst-plugins-base orc ]
    ++ (if useInternalFfmpeg then [ yasm ] else [ ffmpeg ]);

  meta = {
    homepage = https://gstreamer.freedesktop.org/releases/gst-ffmpeg;
    description = "GStreamer's plug-in using FFmpeg";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
