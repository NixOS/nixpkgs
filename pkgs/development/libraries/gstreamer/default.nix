{ callPackage
, AVFoundation
, AudioToolbox
, Cocoa
, CoreFoundation
, CoreMedia
, CoreServices
, CoreVideo
, DiskArbitration
, Foundation
, IOKit
, MediaToolbox
, OpenGL
, VideoToolbox
, ipu6ep-camera-hal
}:

{
  gstreamer = callPackage ./core { inherit Cocoa CoreServices; };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { inherit Cocoa OpenGL; };

  gst-plugins-good = callPackage ./good { inherit Cocoa; };

  gst-plugins-bad = callPackage ./bad { inherit AudioToolbox AVFoundation Cocoa CoreMedia CoreVideo Foundation MediaToolbox VideoToolbox; };

  gst-plugins-ugly = callPackage ./ugly { inherit CoreFoundation DiskArbitration IOKit; };

  gst-plugins-viperfx = callPackage ./viperfx { };

  gst-rtsp-server = callPackage ./rtsp-server { };

  gst-libav = callPackage ./libav { };

  gst-devtools = callPackage ./devtools { };

  gst-editing-services = callPackage ./ges { };

  gst-vaapi = callPackage ./vaapi { };

  icamerasrc-ipu6 = callPackage ./icamerasrc { };
  icamerasrc-ipu6ep = callPackage ./icamerasrc {
    ipu6-camera-hal = ipu6ep-camera-hal;
  };

  # note: gst-python is in ./python/default.nix - called under pythonPackages
}
