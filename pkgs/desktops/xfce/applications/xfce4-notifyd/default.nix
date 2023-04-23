{ lib
, mkXfceDerivation
, glib
, gtk3
, libcanberra-gtk3
, libnotify
, libxfce4ui
, libxfce4util
, sqlite
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.8.2";

  sha256 = "sha256-M8L2HWTuQDl/prD7s6uptkW4XDscpk6fc+epoxjFNS8=";

  buildInputs = [
    gtk3
    glib
    libcanberra-gtk3
    libnotify
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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
