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
, libxklavier
, pam
, systemd
, xfconf
, lib
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screensaver";
  version = "4.16.0";

  sha256 = "1vblqhhzhv85yd5bz1xg14yli82ys5qrjdcabg3l53glbk61n99p";

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
    libxklavier
    pam
    systemd
    xfconf
  ];

  configureFlags = [ "--without-console-kit" ];

  makeFlags = [ "DBUS_SESSION_SERVICE_DIR=$(out)/etc" ];

  meta =  {
    description = "Screensaver for Xfce";
    maintainers = with lib.maintainers; [ symphorien ];
  };
}
