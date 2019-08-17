{ mkXfceDerivation, dbus, dbus-glib
, gst-plugins-bad, gst-plugins-base, gst-plugins-good
, gst-plugins-ugly, gtk3, libnotify, libxfce4ui, libxfce4util
, taglib, xfconf }:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation rec {
  category = "apps";
  pname = "parole";
  version = "1.0.4";

  sha256 = "18j4bmny37crryh4pvxcjjvj99mln6ljq2vy69awxhvrjx9ljv13";

  postPatch = ''
    substituteInPlace src/plugins/mpris2/Makefile.am \
      --replace GST_BASE_CFLAGS GST_VIDEO_CFLAGS
  '';

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
