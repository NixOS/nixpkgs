{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-battery-plugin";
  version = "1.1.2";
  rev-prefix = "";
  odd-unstable = false;
  sha256 = "0329miiclc8da6j0sz495p99hyrf9fjhvpmdl0556fphybz5agc0";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Battery plugin for Xfce panel";
  };
}
