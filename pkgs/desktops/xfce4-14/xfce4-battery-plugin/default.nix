{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-battery-plugin";
  version = "1.1.2";
  rev = version;
  sha256 = "0329miiclc8da6j0sz495p99hyrf9fjhvpmdl0556fphybz5agc0";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];
}
