{ lib, mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-netload-plugin";
  version = "1.4.0";
  rev-prefix = "xfce4-netload-plugin-";
  odd-unstable = false;
  sha256 = "sha256-HasaMymMCPidYkaAUK4gvD+Ka7NJdFOTeq43gJ1G3jo=";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = with lib; {
    description = "Internet load speed plugin for Xfce4 panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
