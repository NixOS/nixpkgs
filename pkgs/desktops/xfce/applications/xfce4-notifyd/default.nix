{
  lib,
  mkXfceDerivation,
  dbus,
  glib,
  gtk3,
  gtk-layer-shell,
  libcanberra-gtk3,
  libnotify,
  libX11,
  libxfce4ui,
  libxfce4util,
  sqlite,
  xfce4-panel,
  xfconf,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.9.7";
  odd-unstable = false;

  sha256 = "sha256-pgdoy3mZOGMOBwK/cYEl8fre4fZo2lfyWzZnrSYlQ64=";

  buildInputs = [
    dbus
    gtk3
    gtk-layer-shell
    glib
    libcanberra-gtk3
    libnotify
    libX11
    libxfce4ui
    libxfce4util
    sqlite
    xfce4-panel
    xfconf
  ];

  configureFlags = [
    "--enable-dbus-start-daemon"
    "--enable-sound"
  ];

  meta = with lib; {
    description = "Simple notification daemon for Xfce";
    mainProgram = "xfce4-notifyd-config";
    teams = [ teams.xfce ];
  };
}
