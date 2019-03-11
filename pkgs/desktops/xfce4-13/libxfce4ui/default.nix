{ lib, mkXfceDerivation, gobject-introspection, gtk2, gtk3, libICE, libSM
, libstartup_notification ? null, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.13.4";

  sha256 = "0m9h3kvkk2nx8pxxmsg9sjnyp6ajwjrz9djjxxvranjsdw3ilydy";

  buildInputs =  [ gobject-introspection gtk2 gtk3 libstartup_notification xfconf ];
  propagatedBuildInputs = [ libxfce4util libICE libSM ];

  meta = with lib; {
    description = "Widgets library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
