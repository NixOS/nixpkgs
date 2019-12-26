{ mkXfceDerivation, gtk3, libXtst, libxfce4ui, libxfce4util, xfce4-panel, xfconf, exo }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.4.3";
  rev = version;
  sha256 = "1xk79xh1zk0x4r1z9m1dakp79pip0zh3naviybvl1dnpwwfc03gq";

  buildInputs = [ exo gtk3 libXtst libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Clipboard manager for Xfce panel";
  };
}
