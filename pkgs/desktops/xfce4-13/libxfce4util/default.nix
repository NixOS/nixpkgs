{ lib, mkXfceDerivation, gobjectIntrospection }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.13.1";

  sha256 = "001ls90an2pi9l04g3r6syfa4lhyvjymp0r9djxrkc2q493mcv3d";

  buildInputs = [ gobjectIntrospection ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
