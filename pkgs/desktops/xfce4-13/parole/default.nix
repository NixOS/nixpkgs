{ mkXfceDerivation, makeWrapper, wrapGAppsHook, dbus, dbus_glib
, gst-plugins-bad ? null, gst-plugins-base, gst-plugins-good
, gst-plugins-ugly ? null, gtk3, libnotify, libxfce4ui, libxfce4util
, taglib ? null, xfconf }:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation rec {
  category = "apps";
  pname = "parole";
  version = "0.9.2";

  sha256 = "07i9d7xn2ys3z71sxvr53idq4ivy94pqgxvr0k78crva39ls08s5";

  postPatch = ''
    substituteInPlace src/plugins/mpris2/Makefile.am \
      --replace GST_BASE_CFLAGS GST_VIDEO_CFLAGS
  '';

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];

  buildInputs = [
    dbus
    dbus_glib
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
