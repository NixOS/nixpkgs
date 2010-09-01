{ fetchurl, stdenv, pkgconfig, gstPluginsBase, bzip2 }:

stdenv.mkDerivation rec {
  name = "gst-ffmpeg-0.10.11";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-ffmpeg/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "0bk9k9sccx9nvhjakacvq8gd6vp63x9ddmjrqkfdhkmgwlwa2dpz";
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
