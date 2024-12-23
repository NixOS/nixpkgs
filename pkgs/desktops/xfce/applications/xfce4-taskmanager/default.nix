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
  version = "1.5.7";
  odd-unstable = false;

  sha256 = "sha256-znadP7rrP/IxH22U1D9p6IHZ1J1JfXoCVk8iKUgrkJw=";

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
