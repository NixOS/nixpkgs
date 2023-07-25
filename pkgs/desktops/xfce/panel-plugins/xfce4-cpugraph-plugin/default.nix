{ lib
, mkXfceDerivation
, exo
, glib
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
  version = "1.2.8";
  rev-prefix = "xfce4-cpugraph-plugin-";
  odd-unstable = false;
  sha256 = "sha256-GNoODnw9Z9MTlvxCOTeZt61A/0AGhMwjrRGdM35XU+M=";

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

  meta = with lib; {
    description = "CPU graph show for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
