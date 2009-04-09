args: with args;
rec {
  gstreamer = import ./gstreamer {
    inherit (args) fetchurl stdenv perl bison flex
       pkgconfig python which gtkdoc glib libxml2;
  };

  gstPluginsBaseFun = lib.sumArgs (selectVersion ./gst-plugins-base "0.10.21")
    args { inherit gstreamer; };
  gstPluginsBase = gstPluginsBaseFun null;

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
