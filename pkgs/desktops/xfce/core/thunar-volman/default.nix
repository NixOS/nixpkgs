{ mkXfceDerivation, exo, gtk3, libgudev, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "thunar-volman";
  version = "0.9.5";

  buildInputs = [ exo gtk3 libgudev libxfce4ui libxfce4util xfconf ];

  sha256 = "1qrlpn0q5g9psd41l6y80r3bvbg8jaic92m6r400zzwcvivf95z0";

  meta = {
    description = "Thunar extension for automatic management of removable drives and media";
  };
}
