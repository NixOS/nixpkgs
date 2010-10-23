{ callPackage, pkgs }:

rec {
  gstreamer = callPackage ./gstreamer {
    flex = pkgs.flex2535;
  };

  gstPluginsBase = callPackage ./gst-plugins-base { };

  gstPluginsGood = callPackage ./gst-plugins-good { };

  gstFfmpeg = callPackage ./gst-ffmpeg { };

  gnonlin = callPackage ./gnonlin { };

  # Header files are in include/${prefix}/
  prefix = "gstreamer-0.10";
}
