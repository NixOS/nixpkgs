{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "garcon";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "0gmvi6m3iww7m3xxx5wiqd8vsi18igzhcpjfzknfc8z741vc38yj";

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];
}
