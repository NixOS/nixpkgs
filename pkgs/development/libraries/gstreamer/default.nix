{
  config,
  lib,
  newScope,
  apple-sdk,
  gstreamer,
  gstreamermm,
  gst-plugins-base,
  gst-plugins-good,
  gst-plugins-bad,
  gst-plugins-ugly,
  gst-plugins-rs,
  gst-rtsp-server,
  gst-libav,
  gst-devtools,
  gst-editing-services,
  icamerasrc-ipu6,
  icamerasrc-ipu6ep,
  icamerasrc-ipu6epmtl,
  icamerasrc-ipu7x,
  icamerasrc-ipu75xa,
}:

lib.makeScope newScope (
  self:
  {
    apple-sdk_gstreamer = apple-sdk;

    inherit
      gstreamer
      gstreamermm
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-plugins-rs
      gst-rtsp-server
      gst-libav
      gst-devtools
      gst-editing-services
      icamerasrc-ipu6
      icamerasrc-ipu6ep
      icamerasrc-ipu6epmtl
      icamerasrc-ipu7x
      icamerasrc-ipu75xa
      ;

    # note: gst-python is in ../../python-modules/gst-python - called under python3Packages
  }
  // lib.optionalAttrs config.allowAliases {
    gst-plugins-viperfx = throw "'gst_all_1.gst-plugins-viperfx' was removed as it is broken and not maintained upstream"; # Added 2024-12-16
    gst-vaapi = throw "'gst_all_1.gst-vaapi' has been removed in GStreamer 1.28. Users are recommended to switch to gst-plugins-bad, however it is not an in-place upgrade."; # Added 2026-06-28
  }
)
