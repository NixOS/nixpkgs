{ mkXfceDerivation, dbus, dbus-glib
, gst_all_1, gtk3, libnotify, libxfce4ui, libxfce4util
, taglib, xfconf }:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation {
  category = "apps";
  pname = "parole";
  version = "4.16.0";

  sha256 = "07hcnbcd56lq7z3gq1cnk71ppy98hwdvlfp5z3zlc55cqrry26zm";

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
