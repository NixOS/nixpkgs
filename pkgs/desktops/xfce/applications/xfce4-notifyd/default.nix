{ lib, mkXfceDerivation, glib, gtk3, libnotify, libxfce4ui, libxfce4util
, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.6.3";

  sha256 = "sha256-JcHxqKLl4F4FQv7lE64gWUorCvl5g5mSD+jEmj1ORfY=";

  buildInputs = [ gtk3 glib libnotify libxfce4ui libxfce4util xfce4-panel xfconf ];

  configureFlags = [
    "--enable-dbus-start-daemon"
  ];

  meta = with lib; {
    description = "Simple notification daemon for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
