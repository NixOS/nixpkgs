{ mkXfceDerivation, dbus, dbus-glib
, gst_all_1, gtk3, libnotify, libxfce4ui, libxfce4util
, taglib, xfconf }:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation {
  category = "apps";
  pname = "parole";
  version = "1.0.5";

  sha256 = "0qgis2gnkcvg7xwp76cbi0ihqdjprvvw2d66hk7klhrafp7c0v13";

  postPatch = ''
    substituteInPlace src/plugins/mpris2/Makefile.am \
      --replace GST_BASE_CFLAGS GST_VIDEO_CFLAGS
  '';

  buildInputs = with gst_all_1; [
    dbus
    dbus-glib
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    taglib
    xfconf
  ];

  meta = {
    description = "Modern simple media player";
  };
}
