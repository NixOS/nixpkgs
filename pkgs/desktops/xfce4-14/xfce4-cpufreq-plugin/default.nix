{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-cpufreq-plugin";
  version = "1.2.1";
  sha256 = "1p7c4g3yfc19ksdckxpzq1q35jvplh5g55299cvv0afhdb5l8zhv";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];
}
