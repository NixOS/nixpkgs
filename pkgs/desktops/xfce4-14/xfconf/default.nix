{ mkXfceDerivation, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfconf";
  version = "4.14.1";

  sha256 = "1mbqc1463xgn7gafbh2fyshshdxin33iwk96y4nw2gl48nhx4sgs";

  buildInputs = [ libxfce4util ];
}
