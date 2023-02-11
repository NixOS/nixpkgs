{ lib, mkXfceDerivation, exo, librsvg, dbus-glib, libepoxy, gtk3, libXdamage
, libstartup_notification, libxfce4ui, libxfce4util, libwnck
, libXpresent, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfwm4";
  version = "4.18.0";

  sha256 = "sha256-nTPgxC0XMBJ48lPCeQgCvWWK1/2ZIoQOYsMeaxDpE1c=";

  nativeBuildInputs = [ exo librsvg ];

  buildInputs = [
    dbus-glib
    libepoxy
    gtk3
    libXdamage
    libstartup_notification
    libxfce4ui
    libxfce4util
    libwnck
    libXpresent
    xfconf
  ];

  meta = with lib; {
    description = "Window manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
