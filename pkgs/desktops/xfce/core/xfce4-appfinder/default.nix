{
  lib,
  mkXfceDerivation,
  exo,
  garcon,
  gtk3,
  libxfce4util,
  libxfce4ui,
  xfconf,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.20.0";

  sha256 = "sha256-HovQnkfv5BOsRPowgMkMEWQmESkivVK0Xb7I15ZaOMc=";

  nativeBuildInputs = [ exo ];
  buildInputs = [
    garcon
    gtk3
    libxfce4ui
    libxfce4util
    xfconf
  ];

  meta = with lib; {
    description = "Appfinder for the Xfce4 Desktop Environment";
    teams = [ teams.xfce ];
  };
}
