{
  lib,
  mkXfceDerivation,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  pcre2,
  xfce4-panel,
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-verve-plugin";
  version = "2.0.4";
  sha256 = "sha256-j0uKYj9PeLEVaocHRw87Dz+YFqDr1BImejEpDPYObQg=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    pcre2
    xfce4-panel
  ];

  meta = with lib; {
    description = "Command-line plugin";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
