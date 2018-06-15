{ mkXfceDerivation, exo, dbus_glib, epoxy ? null, gtk2, libICE, libSM
, libstartup_notification ? null, libxfce4ui, libxfce4util, libwnck
, libXpresent ? null, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfwm4";
  version = "4.13.0";

  sha256 = "19ikyls4xawsbz07qdz60g5yl2jbvpb90sfy5zql7ghypd69cgn9";

  nativeBuildInputs = [ exo ];

  buildInputs = [
    dbus_glib
    epoxy
    gtk2
    libICE
    libSM
    libstartup_notification
    libxfce4ui
    libxfce4util
    libwnck
    libXpresent
    xfconf
  ];
}
