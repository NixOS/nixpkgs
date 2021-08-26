{ lib, mkXfceDerivation, gobject-introspection, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "4.16.1";

  sha256 = "sha256-KimO6w82lkUBSzJbBMI3W8w1eXPARE1oVyJEUk6olow=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  meta = {
    description = "Xfce menu support library";
    license = with lib.licenses; [ lgpl2Only fdl11Only ];
  };
}
