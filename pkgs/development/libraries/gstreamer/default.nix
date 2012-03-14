{ callPackage }:

rec {
  gstreamer = callPackage ./gstreamer { };

  gstPluginsBase = callPackage ./gst-plugins-base { };

  gstPluginsGood = callPackage ./gst-plugins-good { };

  gstPluginsUgly = callPackage ./gst-plugins-ugly { };

  gstPluginsBad = callPackage ./gst-plugins-bad { };

  gstFfmpeg = callPackage ./gst-ffmpeg { };

  gnonlin = callPackage ./gnonlin { };

  gst_python = callPackage ./gst-python {};

  qt_gstreamer = callPackage ./qt-gstreamer {};

  # Header files are in include/${prefix}/
  prefix = "gstreamer-0.10";
}
