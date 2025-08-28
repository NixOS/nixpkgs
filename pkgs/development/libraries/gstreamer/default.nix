{
  config,
  lib,
  callPackage,
  ipu6ep-camera-hal,
  ipu6epmtl-camera-hal,
  apple-sdk_13,
}:

let
  apple-sdk_gstreamer = apple-sdk_13;
in
{
  inherit apple-sdk_gstreamer;

  gstreamer = callPackage ./core { };

  gstreamermm = callPackage ./gstreamermm { };

  gst-plugins-base = callPackage ./base { };

  gst-plugins-good = callPackage ./good { };

  gst-plugins-bad = callPackage ./bad { };

  gst-plugins-ugly = callPackage ./ugly { };

  gst-plugins-rs = callPackage ./rs { };

  gst-rtsp-server = callPackage ./rtsp-server { };

  gst-libav = callPackage ./libav { };

  gst-devtools = callPackage ./devtools { };

  gst-editing-services = callPackage ./ges { };

  gst-vaapi = callPackage ./vaapi { };

  icamerasrc-ipu6 = callPackage ./icamerasrc { };
  icamerasrc-ipu6ep = callPackage ./icamerasrc {
    ipu6-camera-hal = ipu6ep-camera-hal;
  };
  icamerasrc-ipu6epmtl = callPackage ./icamerasrc {
    ipu6-camera-hal = ipu6epmtl-camera-hal;
  };

  # note: gst-python is in ../../python-modules/gst-python - called under python3Packages
}
// lib.optionalAttrs config.allowAliases {
  gst-plugins-viperfx = throw "'gst_all_1.gst-plugins-viperfx' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
}
