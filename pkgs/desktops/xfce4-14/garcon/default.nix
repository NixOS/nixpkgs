{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "garcon";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "0d2fir4vbfdmng9k70nf5zv3fjwgr6g0czrp458x6qswih2gv2ik";

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];
}
