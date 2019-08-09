{ mkXfceDerivation, exo, gtk3, libgudev, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar-volman";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  buildInputs = [ exo gtk3 libgudev libxfce4ui libxfce4util xfconf ];

  sha256 = "0jl863z6rxz50vqa31s58dfn429yn5x8scg492bvgl4cnmni6a30";
}
