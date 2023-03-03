{ lib, mkXfceDerivation, gobject-introspection, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "4.18.0";

  sha256 = "sha256-l1wGitD8MM1GrR4FyyPIxHSqK+AqKKyjTIN7VOaVzpM=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  meta = with lib; {
    description = "Xfce menu support library";
    license = with licenses; [ lgpl2Only fdl11Only ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
