{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: let
  inherit (self) callPackage;
in {

  gstreamer = callPackage ./core {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { };

  gst-plugins-good = callPackage ./good { };

  gst-plugins-bad = callPackage ./bad { };

  gst-plugins-ugly = callPackage ./ugly { };

  gst-rtsp-server = callPackage ./rtsp-server { };

  gst-libav = callPackage ./libav { libav = pkgs.ffmpeg; };

  gst-devtools = callPackage ./devtools { };

  gst-editing-services = callPackage ./ges { };

  gst-vaapi = callPackage ./vaapi { };

  # note: gst-python is in ./python/default.nix - called under pythonPackages
})
