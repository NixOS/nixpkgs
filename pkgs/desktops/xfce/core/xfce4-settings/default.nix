{
  lib,
  mkXfceDerivation,
  wayland-scanner,
  exo,
  garcon,
  gtk3,
  gtk-layer-shell,
  glib,
  libnotify,
  libX11,
  libXext,
  libxfce4ui,
  libxfce4util,
  libxklavier,
  withXrandr ? true,
  upower,
  # Disabled by default on upstream and actually causes issues:
  # https://gitlab.xfce.org/xfce/xfce4-settings/-/issues/222
  withUpower ? false,
  wlr-protocols,
  xfconf,
  xf86inputlibinput,
  colord,
  withColord ? true,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.20.2";

  sha256 = "sha256-hx1ilXPcwWWDwNR/k2b+9vR5aCv9UlPR0d42OE6JxEk=";

  nativeBuildInputs = [
    wayland-scanner
  ];

  buildInputs = [
    exo
    garcon
    glib
    gtk3
    gtk-layer-shell
    libnotify
    libX11
    libXext
    libxfce4ui
    libxfce4util
    libxklavier
    wlr-protocols
    xf86inputlibinput
    xfconf
  ]
  ++ lib.optionals withUpower [ upower ]
  ++ lib.optionals withColord [ colord ];

  configureFlags = [
    "--enable-pluggable-dialogs"
    "--enable-sound-settings"
    (lib.enableFeature withXrandr "xrandr")
  ]
  ++ lib.optionals withUpower [ "--enable-upower-glib" ]
  ++ lib.optionals withColord [ "--enable-colord" ];

  meta = with lib; {
    description = "Settings manager for Xfce";
    teams = [ teams.xfce ];
  };
}
