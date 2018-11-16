{ lib, mkXfceDerivation, gobjectIntrospection }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.13.2";

  sha256 = "0sb6pzhmh0qzfdhixj1ard56zi68318k86z3a1h3f2fhqy7gyf98";

  buildInputs = [ gobjectIntrospection ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
