{ lib
, mkXfceDerivation
, exo
, gtk3
, libXtst
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
, xorgproto
}:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname  = "xfce4-cpugraph-plugin";
  version = "1.2.7";
  rev-prefix = "xfce4-cpugraph-plugin-";
  odd-unstable = false;
  sha256 = "sha256-IgxljHJAg9Bp/OFFZiQ6QwE5vtAtQ0WmYHs78NVsmCw=";

  buildInputs = [
    exo
    gtk3
    libXtst
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
    xorgproto
  ];

  meta = with lib; {
    description = "CPU graph show for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
