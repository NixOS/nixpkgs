{ mkXfceDerivation, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfconf";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "056r2dkkw8hahqin1p5k8rz0r9r0z8piniy855nd1ns0mx2sh47k";

  buildInputs = [ libxfce4util ];
}
