{ mkXfceDerivation, exo, garcon, gtk2, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.13.2";

  sha256 = "194pihmg7af4x81nia2fy3h7rls306a7c0bqny9ycqikvi6nmdmn";

  buildInputs = [ exo garcon gtk2 gtk3 libxfce4ui libxfce4util libwnck3 xfconf ];

  meta =  {
    description = "Xfce's panel";
  };
}
