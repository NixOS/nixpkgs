{ mkXfceDerivation, exo, garcon, gtk3, libxfce4util, libxfce4ui, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.14.0";

  sha256 = "04h7jxfm3wkxnxfy8149dckay7i160vvk4p9lnq6xny22r4x20h8";

  nativeBuildInputs = [ exo ];
  buildInputs = [ garcon gtk3 libxfce4ui libxfce4util xfconf ];
}
