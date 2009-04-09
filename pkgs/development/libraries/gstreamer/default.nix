args: with args;
rec {
  gstreamer = import ./gstreamer {
    inherit (args) fetchurl stdenv perl bison flex
       pkgconfig python which gtkdoc glib libxml2;
  };

  gstPluginsBase = import ./gst-plugins-base {
    inherit gstreamer;
    inherit (args) fetchurl stdenv pkgconfig python
      libX11 libXv libXext alsaLib cdparanoia libogg libtheora
      libvorbis freetype pango liboil gtk which gtkdoc;
  };

  gstPluginsGood = import ./gst-plugins-good {
    inherit gstPluginsBase;
    inherit (args) fetchurl stdenv pkgconfig aalib cairo flac hal
      libjpeg zlib speex libpng libdv libcaca dbus libiec61883
      libavc1394 ladspaH taglib gdbm pulseaudio;
  };

  gstFfmpeg = import ./gst-ffmpeg {
    inherit fetchurl stdenv pkgconfig gstPluginsBase bzip2;
  };

  gnonlin = import ./gnonlin {
    inherit fetchurl stdenv pkgconfig gstreamer gstPluginsBase;
  };
}
