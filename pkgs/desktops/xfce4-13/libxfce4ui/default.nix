{ lib, mkXfceDerivation, gobject-introspection, gtk2, gtk3, libICE, libSM
, libstartup_notification ? null, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "0z4sadqwp71b3qmxlbms26d8vnxd9cks84mr2f1qaiww6rp7v69y";

  buildInputs =  [ gobject-introspection gtk2 gtk3 libstartup_notification xfconf ];
  propagatedBuildInputs = [ libxfce4util libICE libSM ];

  meta = with lib; {
    description = "Widgets library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
