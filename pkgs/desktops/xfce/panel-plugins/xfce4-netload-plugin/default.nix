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
  version = "1.4.2";
  rev-prefix = "xfce4-netload-plugin-";
  odd-unstable = false;
  sha256 = "sha256-g4pkNzggVjC0AuUnJeleR3RQCrneetjDyv8eCXmrYzI=";

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
