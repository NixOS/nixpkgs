{
  lib,
  mkXfceDerivation,
  dbus,
  dbus-glib,
  gst_all_1,
  gtk3,
  libnotify,
  libX11,
  libxfce4ui,
  libxfce4util,
  taglib,
  xfconf,
}:

# Doesn't seem to find H.264 codec even though built with gst-plugins-bad.

mkXfceDerivation {
  category = "apps";
  pname = "parole";
  version = "4.18.2";

  sha256 = "sha256-C4dGiMYn51YuASsQeQs3Cbc+KkPqcOrsCMS+dYfP+Ps=";

  buildInputs = with gst_all_1; [
    dbus
    dbus-glib
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gtk3
    libnotify
    libX11
    libxfce4ui
    libxfce4util
    taglib
    xfconf
  ];

  meta = with lib; {
    description = "Modern simple media player";
    mainProgram = "parole";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
