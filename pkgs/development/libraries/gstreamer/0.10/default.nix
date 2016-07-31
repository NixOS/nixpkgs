{ pkgs, bison2, ffmpeg_0, boost155 }:
let
  callPackage = pkgs.newScope (pkgs // gst_all);
  gst_all = rec {
    gnonlin = callPackage ./gnonlin { };

    gst-ffmpeg = callPackage ./gst-ffmpeg {
      ffmpeg = ffmpeg_0;
    };

    gst-plugins-bad = callPackage ./gst-plugins-bad { };

    gst-plugins-base = callPackage ./gst-plugins-base { };

    gst-plugins-good = callPackage ./gst-plugins-good { };

    gst-plugins-ugly = callPackage ./gst-plugins-ugly { };

    gst-python = callPackage ./gst-python { };

    gstreamer = callPackage ./gstreamer {
      bison = bison2;
    };

    gstreamermm = callPackage ./gstreamermm { };

    qt-gstreamer = callPackage ./qt-gstreamer {
      boost = boost155;
    };

    # Legacy aliases
    gst_ffmpeg = gst-ffmpeg;
    gst_plugins_bad = gst-plugins-bad;
    gst_plugins_base = gst-plugins-base;
    gst_plugins_good = gst-plugins-good;
    gst_plugins_ugly = gst-plugins-ugly;
    gst_python = gst-python;
    qt_gstreamer = qt-gstreamer;
  };
in
  gst_all
