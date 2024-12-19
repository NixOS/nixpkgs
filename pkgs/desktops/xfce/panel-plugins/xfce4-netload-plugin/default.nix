{
  lib,
  mkXfceDerivation,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-netload-plugin";
  version = "1.4.1";
  rev-prefix = "xfce4-netload-plugin-";
  odd-unstable = false;
  sha256 = "sha256-PwbyYi9EeSTKilVXlbseY2zkabcL7o2CGnk2DFFVI94=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  meta = with lib; {
    description = "Internet load speed plugin for Xfce4 panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
