{ lib, mkXfceDerivation, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.18.1";

  sha256 = "sha256-nqASXyHR7wNiNPorlz2ix+Otyir6I9KCCr1vfS6GO8E=";

  nativeBuildInputs = [ gobject-introspection vala ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
