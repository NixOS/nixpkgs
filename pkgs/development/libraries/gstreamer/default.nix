{ callPackage, libva-full }:

rec {
  gstreamer = callPackage ./core { };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { inherit gstreamer; };

  gst-plugins-good = callPackage ./good { inherit gst-plugins-base; };

  gst-plugins-bad = callPackage ./bad { inherit gst-plugins-base; };

  gst-plugins-ugly = callPackage ./ugly { inherit gst-plugins-base; };

  gst-libav = callPackage ./libav { inherit gst-plugins-base; };

  gnonlin = callPackage ./gnonlin { inherit gst-plugins-base; };

  # TODO: gnonlin is deprecated in gst-editing-services, better switch to nle
  # (Non Linear Engine).
  gst-editing-services = callPackage ./ges { inherit gnonlin; };

  gst-vaapi = callPackage ./vaapi {
    inherit gst-plugins-base gstreamer gst-plugins-bad;
    libva = libva-full; # looks also for libva-{x11,wayland}
  };

  gst-validate = callPackage ./validate { inherit gst-plugins-base; };
}
