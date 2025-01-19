{ lib, mkXfceDerivation, exo, librsvg, dbus-glib, libepoxy, gtk3, libXdamage
, libstartup_notification, libxfce4ui, libxfce4util, libwnck
, libXpresent, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfwm4";
  version = "4.20.0";

  sha256 = "sha256-5UZQrAH0oz+G+7cvXCLDJ4GSXNJcyl4Ap9umb7h0f5Q=";

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
