{ lib, mkXfceDerivation, gobject-introspection, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "4.18.2";

  sha256 = "sha256-J9f9MzZ1I9XIyvwuyINkvXDuXY6/MkjlH2Ct4yaEXsY=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  meta = with lib; {
    description = "Xfce menu support library";
    license = with licenses; [ lgpl2Only fdl11Only ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
