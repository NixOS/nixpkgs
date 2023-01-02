{ lib
, mkXfceDerivation
, exo
, libxml2
, libsoup_3
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.10.1";
  odd-unstable = false;

  sha256 = "sha256-TKtEKjRmrdhi1nFRo1OovmPndT2RTYV9kt7auBDESmE=";

  buildInputs = [
    exo
    libxml2
    libsoup_3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Screenshot utility for the Xfce desktop";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
