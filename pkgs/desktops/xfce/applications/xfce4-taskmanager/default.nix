{ lib
, mkXfceDerivation
, exo
, gtk3
, libxfce4ui
, xfconf
, libwnck
, libXmu
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.5.5";
  odd-unstable = false;

  sha256 = "sha256-worHYB9qibRxMaCYQ0+nHA9CSTColewgahyrXiPOnQA=";

  nativeBuildInputs = [
    exo
  ];

  buildInputs = [
    gtk3
    libxfce4ui
    xfconf
    libwnck
    libXmu
  ];

  meta = with lib; {
    description = "Easy to use task manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
