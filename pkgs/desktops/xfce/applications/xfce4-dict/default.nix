{ lib
, mkXfceDerivation
, glib
, gtk3
, libxfce4ui
, libxfce4util
, xfce4-panel
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.7";

  sha256 = "sha256-1xjprnQG2P+LYAhEGxdu1wpoP/+C+udmNqb/3zEojr0=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  meta = with lib; {
    description = "Dictionary Client for the Xfce desktop environment";
    mainProgram = "xfce4-dict";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
