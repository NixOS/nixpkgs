{ lib
, mkXfceDerivation
, glib
, gtk3
, libnotify
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.6.4";

  sha256 = "sha256-H/qAfgwM0qaIxpVlSAUJJ4/Z3WtvYxJb2TtjKHK6AjE=";

  buildInputs = [
    gtk3
    glib
    libnotify
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  configureFlags = [
    "--enable-dbus-start-daemon"
  ];

  meta = with lib; {
    description = "Simple notification daemon for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
