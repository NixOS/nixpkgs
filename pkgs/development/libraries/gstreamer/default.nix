{ callPackage }:

rec {
  gstreamer = callPackage ./core { };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { inherit gstreamer; };

  gst-plugins-good = callPackage ./good { inherit gst-plugins-base; };

  gst-plugins-bad = callPackage ./bad { inherit gst-plugins-base; };

  gst-plugins-ugly = callPackage ./ugly { inherit gst-plugins-base; };

  gst-rtsp-server = callPackage ./rtsp-server { inherit gst-plugins-base; };

  gst-libav = callPackage ./libav { inherit gst-plugins-base; };

  gst-editing-services = callPackage ./ges { inherit gst-plugins-base; };

  gst-vaapi = callPackage ./vaapi {
    inherit gst-plugins-base gstreamer gst-plugins-bad;
  };

  gst-validate = callPackage ./validate { inherit gst-plugins-base; };

  # note: gst-python is in ./python/default.nix - called under pythonPackages
}
