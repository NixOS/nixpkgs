{ lib, mkXfceDerivation, gobject-introspection, gtk2, gtk3, libICE, libSM
, libstartup_notification ? null, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "0kvqzf91ygxxkcy4drjminby4c3c42c54a3if8jwx0zmgbml7l8q";

  buildInputs =  [ gobject-introspection gtk2 gtk3 libstartup_notification xfconf ];
  propagatedBuildInputs = [ libxfce4util libICE libSM ];

  meta = with lib; {
    description = "Widgets library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
