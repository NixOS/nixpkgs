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

  gstPluginsGoodFun = lib.sumArgs (selectVersion ./gst-plugins-good "0.10.11")
    args { inherit gstPluginsBase; };
  gstPluginsGood = gstPluginsGoodFun null;

  gstFfmpeg = import ./gst-ffmpeg {
    inherit fetchurl stdenv pkgconfig gstPluginsBase bzip2;
  };

  gnonlin = import ./gnonlin {
    inherit fetchurl stdenv pkgconfig gstreamer gstPluginsBase;
  };
}
