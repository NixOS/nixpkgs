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
  version = "4.20.0";

  buildInputs = [
    exo
    gtk3
    libgudev
    libxfce4ui
    libxfce4util
    xfconf
  ];

  sha256 = "sha256-XIVs/vRwy3QJQW/U7eLBvGdzplWlhdxn3f1lyTQsmpE=";

  odd-unstable = false;

  meta = with lib; {
    description = "Thunar extension for automatic management of removable drives and media";
    teams = [ teams.xfce ];
  };
}
