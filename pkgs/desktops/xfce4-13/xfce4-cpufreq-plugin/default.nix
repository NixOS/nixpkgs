{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-cpufreq-plugin";
  version = "1.2.0";
  sha256 = "0zhs7b7py1njczmpnib4532fwpnd3vnpqfhss2r136cfgy72kp6g";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];
}
