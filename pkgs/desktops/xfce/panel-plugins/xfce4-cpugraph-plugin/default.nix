{
  lib,
  mkXfceDerivation,
  exo,
  glib,
  gtk3,
  libXtst,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  xorgproto,
}:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-cpugraph-plugin";
  version = "1.2.11";
  rev-prefix = "xfce4-cpugraph-plugin-";
  odd-unstable = false;
  sha256 = "sha256-Q+H6riGF5sEcyrVFoDfudwVw4QORa2atE6NTb+xde/w=";

  buildInputs = [
    exo
    glib
    gtk3
    libXtst
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
    xorgproto
  ];

  meta = {
    description = "CPU graph show for Xfce panel";
    maintainers = with lib.maintainers; [ ] ++ lib.teams.xfce.members;
  };
}
