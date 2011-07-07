{ callPackage }:

rec {
  gstreamer = callPackage ./gstreamer { };

  gstPluginsBase = callPackage ./gst-plugins-base { };

  gstPluginsGood = callPackage ./gst-plugins-good { };

  gstFfmpeg = callPackage ./gst-ffmpeg { };

  gnonlin = callPackage ./gnonlin { };

  gst_python = callPackage ./gst-python {};

  # Header files are in include/${prefix}/
  prefix = "gstreamer-0.10";
}
