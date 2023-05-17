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
  version = "4.18.1";

  sha256 = "sha256-d72m2dW8jvM/EjgNSVaKsP5Ip7ioguB61/hy2cWw+dw=";

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

  meta =  {
    description = "Screensaver for Xfce";
    maintainers = with lib.maintainers; [ symphorien ];
  };
}
