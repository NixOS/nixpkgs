{ callPackage, AudioToolbox, AVFoundation, Cocoa, CoreFoundation, CoreMedia, CoreServices, CoreVideo, DiskArbitration, Foundation, IOKit, MediaToolbox, OpenGL, VideoToolbox }:

rec {
  gstreamer = callPackage ./core { inherit CoreServices; };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { inherit gstreamer Cocoa OpenGL; };

  gst-plugins-good = callPackage ./good { inherit gst-plugins-base Cocoa; };

  gst-plugins-bad = callPackage ./bad { inherit gst-plugins-base AudioToolbox AVFoundation CoreMedia CoreVideo Foundation MediaToolbox VideoToolbox; };

  gst-plugins-ugly = callPackage ./ugly { inherit gst-plugins-base CoreFoundation DiskArbitration IOKit; };

  gst-rtsp-server = callPackage ./rtsp-server { inherit gst-plugins-base gst-plugins-bad; };

  gst-libav = callPackage ./libav { inherit gst-plugins-base; };

  gst-devtools = callPackage ./devtools { inherit gstreamer gst-plugins-base; };

  gst-editing-services = callPackage ./ges { inherit gst-plugins-base gst-plugins-bad gst-devtools; };

  gst-vaapi = callPackage ./vaapi {
    inherit gst-plugins-base gstreamer gst-plugins-bad;
  };

  # note: gst-python is in ./python/default.nix - called under pythonPackages
}
