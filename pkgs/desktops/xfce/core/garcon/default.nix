{ lib, mkXfceDerivation, gobject-introspection, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "4.20.0";

  sha256 = "sha256-MeZkDb2QgGMaloO6Nwlj9JmZByepd6ERqpAWqrVv1xw=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  meta = with lib; {
    description = "Xfce menu support library";
    license = with licenses; [ lgpl2Only fdl11Only ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
