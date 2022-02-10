{ lib, mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-cpufreq-plugin";
  version = "1.2.6";
  sha256 = "sha256-HS+9pBCHy0NmDVUwL8QFDPeVpKyKib8YCwV8fZDL5Uc=";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = with lib; {
    description = "CPU Freq load plugin for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
