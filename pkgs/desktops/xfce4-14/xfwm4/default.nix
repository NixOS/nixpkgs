{ mkXfceDerivation, exo, librsvg, dbus-glib, epoxy, gtk3, libXdamage
, libstartup_notification, libxfce4ui, libxfce4util, libwnck3
, libXpresent, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfwm4";
  version = "4.14.0";

  sha256 = "1z5aqij2d8n9wnha88b0qzkvss54jvqs8w1w5m3mzjl4c9mn9n8m";

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
