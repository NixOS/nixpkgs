{
  lib,
  mkXfceDerivation,
  exo,
  gtk3,
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  libyaml,
  xfconf,
  libnotify,
  garcon,
  gtk-layer-shell,
  thunar,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.20.0";

  sha256 = "sha256-80g3lk1TkQI0fbYf2nXs36TrPlaGTHgH6k/TGOzRd3w=";

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libxfce4windowing
    libyaml
    xfconf
    libnotify
    garcon
    gtk-layer-shell
    thunar
  ];

  meta = with lib; {
    description = "Xfce's desktop manager";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
