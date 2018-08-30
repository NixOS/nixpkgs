{ mkXfceDerivation, makeWrapper, wrapGAppsHook, dbus, dbus-glib
, gst-plugins-bad ? null, gst-plugins-base, gst-plugins-good
, gst-plugins-ugly ? null, gtk3, libnotify, libxfce4ui, libxfce4util
, taglib ? null, xfconf }:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation rec {
  category = "apps";
  pname = "parole";
  version = "1.0.1";

  sha256 = "0zq1imbjqmwfk3yrsha2s7lclzbh8xgggz0rbksa51siqk73swbb";

  postPatch = ''
    substituteInPlace src/plugins/mpris2/Makefile.am \
      --replace GST_BASE_CFLAGS GST_VIDEO_CFLAGS
  '';

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];

  buildInputs = [
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
}
