{ fetchurl, stdenv, pkgconfig, gstPluginsBase, bzip2 }:

let version = "0.10.5"; in
  stdenv.mkDerivation rec {
    name = "gst-ffmpeg-${version}";

    src = fetchurl {
      url = "http://gstreamer.freedesktop.org/src/gst-ffmpeg/${name}.tar.bz2";
      sha256 = "12y240jp2lda57frz7pj96izqxcns0k31cc5rp4kdfwwfdsvy5ik";
    };

    propagatedBuildInputs = [ gstPluginsBase ];
    buildInputs = [ pkgconfig bzip2 ];

    configureFlags = "--enable-shared --disable-static --enable-ladspa";

    meta = {
      homepage = "http://gstreamer.freedesktop.org/releases/gst-ffmpeg/${version}.html";

      description = "GStreamer's plug-in using FFmpeg";

      license = "GPLv2+";
    };
  }
