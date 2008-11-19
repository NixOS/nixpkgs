args: with args;
rec {
  gstreamerFun = lib.sumArgs (selectVersion ./gstreamer "0.10.21") args;
  gstreamer = gstreamerFun null;

  gstPluginsBaseFun = lib.sumArgs (selectVersion ./gst-plugins-base "0.10.21")
    args { inherit gstreamer; };
  gstPluginsBase = gstPluginsBaseFun null;

  gstPluginsGoodFun = lib.sumArgs (selectVersion ./gst-plugins-good "0.10.11")
    args { inherit gstPluginsBase; };
  gstPluginsGood = gstPluginsGoodFun null;

  gstFfmpeg = import ./gst-ffmpeg {
    inherit fetchurl stdenv pkgconfig gstPluginsBase bzip2;
  };
}
