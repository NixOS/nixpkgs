{ lib, newScope, ffmpeg }:

lib.makeExtensible (self: with self; {
  callPackage = newScope (self // { libav = ffmpeg; });

  gstreamer = callPackage ./core { };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { };

  gst-plugins-good = callPackage ./good { };

  gst-plugins-bad = callPackage ./bad { };

  gst-plugins-ugly = callPackage ./ugly { };

  gst-rtsp-server = callPackage ./rtsp-server { };

  gst-libav = callPackage ./libav { };

  gst-editing-services = callPackage ./ges { };

  gst-vaapi = callPackage ./vaapi { };

  gst-validate = callPackage ./validate { };

  # note: gst-python is in ./python/default.nix - called under pythonPackages
})
