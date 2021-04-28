{ lib, mkXfceDerivation, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.16.0";

  sha256 = "1p0snipc81dhaq5glv7c1zfq5pcvgq7nikl4ikhfm2af9picfsxb";

  nativeBuildInputs = [ gobject-introspection vala ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
