{ lib, mkXfceDerivation, gtk3, libxfce4ui, pcre, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-verve-plugin";
  version = "2.0.0";
  rev = version;
  sha256 = "09vpa6m0ah7pgmra094c16vb79xrcwva808g6zpawwrhcwz85lcz";

  buildInputs = [ gtk3 libxfce4ui pcre libxfce4util xfce4-panel ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "A command-line plugin";
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
