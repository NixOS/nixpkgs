{ mkXfceDerivation, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfconf";
  version = "4.13.5";

  sha256 = "0xpnwb04yw5qdn0bj8b740a7rmiy316vhja5pp8p6sdiqm32yi8a";

  buildInputs = [ libxfce4util ];
}
