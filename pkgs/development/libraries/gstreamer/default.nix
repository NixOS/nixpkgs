{
  config,
  lib,
  newScope,
  apple-sdk,
  ipu6ep-camera-hal,
  ipu6epmtl-camera-hal,
  ipu75xa-camera-hal,
}:

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    apple-sdk_gstreamer = apple-sdk;

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

    icamerasrc-ipu6 = callPackage ./icamerasrc { };
    icamerasrc-ipu6ep = callPackage ./icamerasrc {
      ipu6-camera-hal = ipu6ep-camera-hal;
    };
    icamerasrc-ipu6epmtl = callPackage ./icamerasrc {
      ipu6-camera-hal = ipu6epmtl-camera-hal;
    };

    icamerasrc-ipu7x = callPackage ./icamerasrc {
      ipuVariant = "ipu7";
    };
    icamerasrc-ipu75xa = callPackage ./icamerasrc {
      ipuVariant = "ipu7";
      ipu7x-camera-hal = ipu75xa-camera-hal;
    };

    # note: gst-python is in ../../python-modules/gst-python - called under python3Packages
  }
  // lib.optionalAttrs config.allowAliases {
    gst-plugins-viperfx = throw "'gst_all_1.gst-plugins-viperfx' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
    gst-vaapi = throw "'gst_all_1.gst-vaapi' has been removed in GStreamer 1.28. Users are recommended to switch to gst-plugins-bad, however it is not an in-place upgrade."; # Added 2026-06-28
  }
)
