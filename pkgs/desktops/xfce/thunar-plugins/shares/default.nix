{
  lib,
  mkXfceDerivation,
  gtk3,
  thunar,
  xfconf,
}:

mkXfceDerivation {
  category = "thunar-plugins";
  pname = "thunar-shares-plugin";
  version = "0.4.0";
  odd-unstable = false;

  sha256 = "sha256-1I5Rkq25ooMnXlnfpTFeZyux8eOPg2sS1p19o11tndQ=";

  buildInputs = [
    gtk3
    thunar
    xfconf
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Thunar plugin providing quick folder sharing using Samba without requiring root access";
    maintainers = with maintainers; [ fgaz ];
    teams = [ teams.xfce ];
  };
}
