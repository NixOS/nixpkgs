{ lib
, mkXfceDerivation
, exo
, garcon
, gtk3
, glib
, libnotify
, libxfce4ui
, libxfce4util
, libxklavier
, upower
, xfconf
, xf86inputlibinput
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-settings";
  version = "4.18.6";

  sha256 = "sha256-xiu26B3dbWu+/AtF/iUC6Wo2U5ZZyzN9RfdbBaQRJ1M=";

  buildInputs = [
    exo
    garcon
    glib
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    libxklavier
    upower
    xf86inputlibinput
    xfconf
  ];

  configureFlags = [
    "--enable-pluggable-dialogs"
    "--enable-sound-settings"
  ];

  meta = with lib; {
    description = "Settings manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
