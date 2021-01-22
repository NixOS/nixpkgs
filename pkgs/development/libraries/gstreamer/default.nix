{ lib, newScope, libav, CoreServices }:

lib.makeScope newScope (self: with self; {
  gstreamer = callPackage ./core { inherit CoreServices; };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { };

  gst-plugins-good = callPackage ./good { };

  gst-plugins-bad = callPackage ./bad { };

  gst-plugins-ugly = callPackage ./ugly { };

  gst-rtsp-server = callPackage ./rtsp-server { };

  gst-libav = callPackage ./libav { inherit libav; };

  gst-devtools = callPackage ./devtools { };

  gst-editing-services = callPackage ./ges { };

  gst-vaapi = callPackage ./vaapi { };

  # note: gst-python is in ./python/default.nix - called under pythonPackages
})
