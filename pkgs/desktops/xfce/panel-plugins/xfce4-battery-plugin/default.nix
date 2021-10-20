{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-battery-plugin";
  version = "1.1.4";
  rev-prefix = "xfce4-battery-plugin-";
  odd-unstable = false;
  sha256 = "sha256-LwwlyWhtVM+OHR9KtE4DPyU5V/dMOjcgSjsI3o7qfk8=";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Battery plugin for Xfce panel";
  };
}
