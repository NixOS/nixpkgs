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
  version = "0.9.6";
  odd-unstable = false;

  sha256 = "sha256-TxVz9fUvuS5bl9eq9isalez3/Pro366TGFMBQ2DfIVI=";

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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
