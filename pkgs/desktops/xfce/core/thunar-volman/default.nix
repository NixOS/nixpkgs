{
  lib,
  mkXfceDerivation,
  exo,
  gtk3,
  libgudev,
  libxfce4ui,
  libxfce4util,
  xfconf,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "thunar-volman";
  version = "4.18.0";

  buildInputs = [
    exo
    gtk3
    libgudev
    libxfce4ui
    libxfce4util
    xfconf
  ];

  sha256 = "sha256-NRVoakU8jTCJVe+iyJQwW1xPti2vjd/8n8CYrIYGII0=";

  odd-unstable = false;

  meta = with lib; {
    description = "Thunar extension for automatic management of removable drives and media";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
