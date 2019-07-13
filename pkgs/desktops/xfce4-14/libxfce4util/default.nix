{ lib, mkXfceDerivation, gobject-introspection }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "0s1fh798v86ifg46qn3zaykpwidn23vpqbkxq1fcbxpxb6rpxxwk";

  buildInputs = [ gobject-introspection ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
