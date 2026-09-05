{
  config,
  lib,
  newScope,
  apple-sdk,
  ipu6ep-camera-hal,
  ipu6epmtl-camera-hal,
}:

let
  # From around version 1.12.0 on, there is a single CPE identifier for all of GStreamer.
  # FIXME: Should gst-plugins-rs follow the main GStreamer versioning or its own deviating version?
  gstreamerCpeParts = version: {
    part = "a";
    vendor = "gstreamer";
    product = "gstreamer";
    inherit version;
    edition = "*";
    sw_edition = "*";
    target_sw = "*";
    target_hw = "*";
    language = "*";
    other = "*";
    update = "*";
  };
in

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    apple-sdk_gstreamer = apple-sdk;

    gstreamer = callPackage ./core { inherit gstreamerCpeParts; };

    gstreamermm = callPackage ./gstreamermm { };

    gst-plugins-base = callPackage ./base { inherit gstreamerCpeParts; };

    gst-plugins-good = callPackage ./good { inherit gstreamerCpeParts; };

    gst-plugins-bad = callPackage ./bad { inherit gstreamerCpeParts; };

    gst-plugins-ugly = callPackage ./ugly { inherit gstreamerCpeParts; };

    gst-plugins-rs = callPackage ./rs { };

    gst-rtsp-server = callPackage ./rtsp-server { inherit gstreamerCpeParts; };

    gst-libav = callPackage ./libav { inherit gstreamerCpeParts; };

    gst-devtools = callPackage ./devtools { inherit gstreamerCpeParts; };

    gst-editing-services = callPackage ./ges { inherit gstreamerCpeParts; };

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
    gst-vaapi = throw "'gst_all_1.gst-vaapi' has been removed in GStreamer 1.28. Users are recommended to switch to gst-plugins-bad, however it is not an in-place upgrade."; # Added 2026-06-28
  }
)
