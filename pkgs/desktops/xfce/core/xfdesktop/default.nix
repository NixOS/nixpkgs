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
  version = "4.20.1";

  sha256 = "sha256-QBzsHXEdTGj8PlgB+L/TJjxAVksKqf+9KrRN3YaBf44=";

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
    teams = [ teams.xfce ];
  };
}
