{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-battery-plugin";
  version = "1.1.3";
  rev-prefix = "";
  odd-unstable = false;
  sha256 = "0ligdiasrfc3170kd7sif2ml6lvlpp11lbxz3xdvklqkv7p3323y";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Battery plugin for Xfce panel";
  };
}
