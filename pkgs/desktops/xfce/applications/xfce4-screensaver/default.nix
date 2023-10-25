{ mkXfceDerivation
, dbus-glib
, garcon
, glib
, gtk3
, libX11
, libXScrnSaver
, libXrandr
, libwnck
, libxfce4ui
, libxfce4util
, libxklavier
, pam
, systemd
, xfconf
, lib
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screensaver";
  version = "4.18.2";

  sha256 = "sha256-j5K5i+hl/miyHste73akZL62K6YTxXmN8mmFK9BCecs=";

  buildInputs = [
    dbus-glib
    garcon
    glib
    gtk3
    libX11
    libXScrnSaver
    libXrandr
    libwnck
    libxfce4ui
    libxfce4util
    libxklavier
    pam
    systemd
    xfconf
  ];

  configureFlags = [ "--without-console-kit" ];

  makeFlags = [ "DBUS_SESSION_SERVICE_DIR=$(out)/etc" ];

  meta = with lib; {
    description = "Screensaver for Xfce";
    maintainers = with maintainers; [ symphorien ] ++ teams.xfce.members;
  };
}
