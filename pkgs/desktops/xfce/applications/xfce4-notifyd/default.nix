{ lib
, mkXfceDerivation
, dbus
, glib
, gtk3
, gtk-layer-shell
, libcanberra-gtk3
, libnotify
, libX11
, libxfce4ui
, libxfce4util
, sqlite
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.9.4";
  odd-unstable = false;

  sha256 = "sha256-oDvP2xE/KvIKl7D5hAwROxhqpli7G/UNd51YCdT7Dv4=";

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

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

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
