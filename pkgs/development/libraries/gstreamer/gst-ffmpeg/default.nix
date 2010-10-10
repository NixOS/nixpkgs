{ fetchurl, stdenv, pkgconfig, gstPluginsBase, bzip2, liboil }:

stdenv.mkDerivation rec {
  name = "gst-ffmpeg-0.10.9";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gst-ffmpeg/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "05cg5jzl8wccsr495hgs7cgdkc6dfi1v218fsm5fv2slgly1pvb3";
  };

  propagatedBuildInputs = [ gstPluginsBase ];
  
  buildInputs = [ pkgconfig bzip2 liboil ];

  configureFlags = "--enable-ladspa";

  meta = {
    homepage = "http://gstreamer.freedesktop.org/releases/gst-ffmpeg";

    description = "GStreamer's plug-in using FFmpeg";

    license = "GPLv2+";
  };
}
