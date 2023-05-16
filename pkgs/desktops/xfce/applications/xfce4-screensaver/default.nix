{ mkXfceDerivation
<<<<<<< HEAD
, gobject-introspection
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, python3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, systemd
, xfconf
, lib
}:

<<<<<<< HEAD
let
  # For xfce4-screensaver-configure
  pythonEnv = python3.withPackages (pp: [ pp.pygobject3 ]);
in
mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screensaver";
  version = "4.18.2";

  sha256 = "sha256-j5K5i+hl/miyHste73akZL62K6YTxXmN8mmFK9BCecs=";

  nativeBuildInputs = [
    gobject-introspection
  ];
=======
mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screensaver";
  version = "4.18.1";

  sha256 = "sha256-d72m2dW8jvM/EjgNSVaKsP5Ip7ioguB61/hy2cWw+dw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    pythonEnv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    systemd
    xfconf
  ];

  configureFlags = [ "--without-console-kit" ];

  makeFlags = [ "DBUS_SESSION_SERVICE_DIR=$(out)/etc" ];

<<<<<<< HEAD
  meta = with lib; {
    description = "Screensaver for Xfce";
    maintainers = with maintainers; [ symphorien ] ++ teams.xfce.members;
=======
  meta =  {
    description = "Screensaver for Xfce";
    maintainers = with lib.maintainers; [ symphorien ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
