{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-cpufreq-plugin";
  version = "1.2.5";
  sha256 = "1isqlfhz1ijl1h3hfvi0n4misdjsrhd7pc9h5rkaqm4vh543ggxg";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "CPU Freq load plugin for Xfce panel";
  };
}
