{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "0.6.4";

  sha256 = "0pamhp1wffiw638s66nws2mpzmwkhvhb6iwccfy8b0kyr57wipjv";

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];
}
