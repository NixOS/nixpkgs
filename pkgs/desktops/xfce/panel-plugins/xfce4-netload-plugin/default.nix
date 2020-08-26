{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-netload-plugin";
  version = "1.3.2";
  rev-prefix = "version-";
  odd-unstable = false;
  sha256 = "1py1l4z5ah4nlq8l2912k47ffsa5z7p1gbvlk7nw6b9r1x4ykdfl";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Battery plugin for Xfce panel";
  };
}
