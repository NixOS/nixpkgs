{ mkXfceDerivation, exo, garcon, gtk3, libxfce4util, libxfce4ui, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "02ds3s7wbpxka7qnliq4c5p428ricdf0jwv01dkfg88gpgqgvswg";

  nativeBuildInputs = [ exo ];
  buildInputs = [ garcon gtk3 libxfce4ui libxfce4util xfconf ];
}
