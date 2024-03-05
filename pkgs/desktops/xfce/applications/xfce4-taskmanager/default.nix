{ lib
, mkXfceDerivation
, exo
, glib
, gtk3
, libxfce4ui
, xfconf
, libwnck
, libX11
, libXmu
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.5.6";
  odd-unstable = false;

  sha256 = "sha256-2NkjaK6xXsrMimriO2/gTOZowt9KTX4MrWJpPXM0w68=";

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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
