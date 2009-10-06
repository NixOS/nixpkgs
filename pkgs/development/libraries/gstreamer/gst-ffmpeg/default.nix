{ fetchurl, stdenv, pkgconfig, gstPluginsBase, bzip2, ... }:

stdenv.mkDerivation rec {
  name = "gst-ffmpeg-0.10.5";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-ffmpeg/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "12y240jp2lda57frz7pj96izqxcns0k31cc5rp4kdfwwfdsvy5ik";
  };

  propagatedBuildInputs = [ gstPluginsBase ];
  
  buildInputs = [ pkgconfig bzip2 ];

  configureFlags = "--enable-ladspa";

  meta = {
    homepage = "http://gstreamer.freedesktop.org/releases/gst-ffmpeg";

    description = "GStreamer's plug-in using FFmpeg";

    license = "GPLv2+";
  };
}
