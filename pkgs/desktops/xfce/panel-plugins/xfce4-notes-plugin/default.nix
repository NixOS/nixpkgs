{
  mkXfceDerivation,
  lib,
  vala,
  glib,
  gtk3,
  gtksourceview4,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-notes-plugin";
  version = "1.11.1";
  sha256 = "sha256-LeKQCsnHVataTP0rYn09x0Ddx8lMtVC0WW/jje7yXag=";
  odd-unstable = false;

  nativeBuildInputs = [
    vala
  ];

  buildInputs = [
    glib
    gtk3
    gtksourceview4
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-notes-plugin";
    description = "Sticky notes plugin for Xfce panel";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ] ++ lib.teams.xfce.members;
  };
}
