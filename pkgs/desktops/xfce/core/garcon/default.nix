{ lib, mkXfceDerivation, gobject-introspection, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "4.16.1";

  sha256 = "134nm1754i12axl4si60fdwkbk2v6z108nrj9c0lb5in1zmqwa9a";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  meta = {
    description = "Xfce menu support library";
    license = with lib.licenses; [ lgpl2Only fdl11Only ];
  };
}
