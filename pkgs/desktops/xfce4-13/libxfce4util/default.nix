{ lib, mkXfceDerivation, gobject-introspection }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "13cqv4b34rmr9h7nr9gmk3x2mi2y0v91xzwrwhikd1lmz9ir5lkf";

  buildInputs = [ gobject-introspection ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
