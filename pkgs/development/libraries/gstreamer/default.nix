{ callPackage }:

rec {
  gstreamer = callPackage ./core { };

  gst-plugins-base = callPackage ./base { inherit gstreamer; };

  gst-plugins-good = callPackage ./good { inherit gst-plugins-base; };

  gst-plugins-bad = callPackage ./bad { inherit gst-plugins-base; };

  gst-plugins-ugly = callPackage ./ugly { inherit gst-plugins-base; };

  gst-libav = callPackage ./libav { inherit gst-plugins-base; };

  gst-python = callPackage ./python { inherit gst-plugins-base gstreamer; };

  gnonlin = callPackage ./gnonlin { inherit gst-plugins-base; };

  gst-editing-services = callPackage ./ges { inherit gnonlin; };
}
