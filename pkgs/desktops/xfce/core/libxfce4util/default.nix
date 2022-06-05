{ lib, mkXfceDerivation, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.16.0";

  sha256 = "sha256-q2vH4k1OiergjITOaA9+m92C3Q/sbPoKVrAFxG60Gtw=";

  nativeBuildInputs = [ gobject-introspection vala ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
