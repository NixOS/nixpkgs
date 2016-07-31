{ pkgs, ffmpeg-full, libva-full, boost155 }:
let
  callPackage = pkgs.newScope (pkgs // gst_all);
  gst_all = rec {
    gstreamer = callPackage ./gstreamer { };

    gstreamermm = callPackage ./gstreamermm { };

    gnonlin = callPackage ./gnonlin { };

    gst-plugins-base = callPackage ./gst-plugins-base { };

    gst-plugins-good = callPackage ./gst-plugins-good { };

    gst-plugins-bad = callPackage ./gst-plugins-bad { };

    gst-plugins-ugly = callPackage ./gst-plugins-ugly { };

    gst-python = callPackage ./gst-python { };

    gst-libav = callPackage ./gst-libav {
      ffmpeg = ffmpeg-full;
    };

    # TODO: gnonlin is deprecated in gst-editing-services, better switch to nle
    # (Non Linear Engine).
    gst-editing-services = callPackage ./gst-editing-services { };

    gst-vaapi = callPackage ./gst-vaapi {
      libva = libva-full; # looks also for libva-{x11,wayland}
    };

    gst-validate = callPackage ./gst-validate { };

    qt-gstreamer = callPackage ./qt-gstreamer {
      boost = boost155;
    };
  };
in
  gst_all
