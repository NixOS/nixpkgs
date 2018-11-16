{ mkXfceDerivation, exo, garcon, gtk3, libxfce4util, libxfce4ui, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.13.0";

  sha256 = "13xsshzw04gx5rhalx4r0khjb0dbq26fv6n20biyiai1ykznyryy";

  nativeBuildInputs = [ exo ];
  buildInputs = [ garcon gtk3 libxfce4ui libxfce4util xfconf ];
}
