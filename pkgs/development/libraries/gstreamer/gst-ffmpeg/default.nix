{ fetchgit, stdenv, autoconf, automake, libtool, pkgconfig
, gst_plugins_base, bzip2, yasm
, useInternalLibAV ? false, libav ? null }:

stdenv.mkDerivation rec {
  name = "gst-ffmpeg-${version}";
  version = "0.11.92";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/gstreamer/gst-ffmpeg";
    rev = "refs/tags/RELEASE-${version}";
    sha256 = "cd0fb825bfceaea64581272e3db812595a7ee1644281bdc466dc1ecc9c46f8b6";
  };

  preConfigure = "autoreconf -vfi";

  # Upstream strongly recommends against using --with-system-ffmpeg,
  # but we do it anyway because we're so hardcore (and we don't want
  # multiple copies of ffmpeg).
  configureFlags = stdenv.lib.optionalString (!useInternalLibAV) "--with-system-libav";

  buildInputs =
    [ autoconf automake libtool pkgconfig bzip2 gst_plugins_base ]
    ++ (if useInternalLibAV then [ yasm ] else [ libav ]);

  meta = {
    homepage = "http://gstreamer.freedesktop.org/releases/gst-ffmpeg";
    description = "GStreamer's plug-in using FFmpeg";
    license = "GPLv2+";
  };
}
