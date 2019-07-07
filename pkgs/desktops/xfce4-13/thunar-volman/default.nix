{ mkXfceDerivation, exo, gtk3, libgudev, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar-volman";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  buildInputs = [ exo gtk3 libgudev libxfce4ui libxfce4util xfconf ];

  sha256 = "1g784yjhjacjnkhr8m62xyhnxlfbwk0fwb366p9kkz035k51idrv";
}
