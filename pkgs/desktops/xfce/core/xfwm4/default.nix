{ lib, mkXfceDerivation, exo, librsvg, dbus-glib, libepoxy, gtk3, libXdamage
, libstartup_notification, libxfce4ui, libxfce4util, libwnck
, libXpresent, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfwm4";
  version = "4.16.1";

  sha256 = "sha256-CwRJk+fqu3iC4Vb6fKGOIZZk2hxTqYF3sNvm6WKqHdI=";

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
