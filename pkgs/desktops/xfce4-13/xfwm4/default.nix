{ mkXfceDerivation, exo, librsvg, dbus-glib, epoxy, gtk3, libXdamage
, libstartup_notification, libxfce4ui, libxfce4util, libwnck3
, libXpresent, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfwm4";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "00nysv5qrv5n4xzyqv4jnsmgljwr2wyynis1gpdbm2kvl5ndxrrd";

  nativeBuildInputs = [ exo librsvg ];

  buildInputs = [
    dbus-glib
    epoxy
    gtk3
    libXdamage
    libstartup_notification
    libxfce4ui
    libxfce4util
    libwnck3
    libXpresent
    xfconf
  ];
}
