{ mkXfceDerivation, makeWrapper, wrapGAppsHook, dbus, dbus-glib
, gst-plugins-bad ? null, gst-plugins-base, gst-plugins-good
, gst-plugins-ugly ? null, gtk3, libnotify, libxfce4ui, libxfce4util
, taglib ? null, xfconf }:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation rec {
  category = "apps";
  pname = "parole";
  version = "1.0.2";

  sha256 = "11i20pvbrcf1jbn77skb1cg72jdmdd0jvmf5khfn91slqky8gcbl";

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
