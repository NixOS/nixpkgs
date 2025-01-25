{ lib
, mkXfceDerivation
, wayland-scanner
, exo
, garcon
, gtk3
, gtk-layer-shell
, glib
, libnotify
, libxfce4ui
, libxfce4util
, libxklavier
, upower
# Disabled by default on upstream and actually causes issues:
# https://gitlab.xfce.org/xfce/xfce4-settings/-/issues/222
, withUpower ? false
, wlr-protocols
, xfconf
, xf86inputlibinput
, colord
, withColord ? true
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.20.0";

  sha256 = "sha256-0fMuAucyxLr2VzQqAB0CL+HgkHNJctiVNZmUmTNzaPc=";

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
  ]
  ++ lib.optionals withUpower [ "--enable-upower-glib" ]
  ++ lib.optionals withColord [ "--enable-colord" ];

  meta = with lib; {
    description = "Settings manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
