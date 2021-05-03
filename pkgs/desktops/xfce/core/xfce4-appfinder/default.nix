{ mkXfceDerivation, exo, garcon, gtk3, libxfce4util, libxfce4ui, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.16.1";

  sha256 = "1r7sjdavqadrpgxqclrznds7a1c2i7mlvghx5mi6qqnh42425gsy";

  nativeBuildInputs = [ exo ];
  buildInputs = [ garcon gtk3 libxfce4ui libxfce4util xfconf ];

  meta = {
    description = "Appfinder for the Xfce4 Desktop Environment";
  };
}
