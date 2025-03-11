{
  lib,
  mkXfceDerivation,
  exo,
  glib,
  gtk3,
  libxfce4ui,
  xfconf,
  libwnck,
  libX11,
  libXmu,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.5.8";
  odd-unstable = false;

  sha256 = "sha256-A2L41YdIpFnbAjQOp+/sJu1oUX9V7jxLsWY7b21frjY=";

  nativeBuildInputs = [
    exo
  ];

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    xfconf
    libwnck
    libX11
    libXmu
  ];

  meta = with lib; {
    description = "Easy to use task manager for Xfce";
    mainProgram = "xfce4-taskmanager";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
