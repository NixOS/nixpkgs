{ lib, mkXfceDerivation, dbus, dbus-glib
, gst_all_1, gtk3, libnotify, libxfce4ui, libxfce4util
, taglib, xfconf }:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation {
  category = "apps";
  pname = "parole";
  version = "4.18.0";

  sha256 = "sha256-TLH9ZUggjclJlbBg3EBVgbcrdiMZ8n+cGDgfNgYNiPI=";

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

  meta = with lib; {
    description = "Modern simple media player";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
