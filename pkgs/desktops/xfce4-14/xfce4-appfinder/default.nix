{ mkXfceDerivation, exo, garcon, gtk3, libxfce4util, libxfce4ui, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "0vr5lx4fv0kldqvqfnsjp6ss7ciz0b2yjq4fhmrhk8czkf8p7va8";

  nativeBuildInputs = [ exo ];
  buildInputs = [ garcon gtk3 libxfce4ui libxfce4util xfconf ];
}
