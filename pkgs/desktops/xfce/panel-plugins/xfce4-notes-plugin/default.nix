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
  version = "1.11.2";
  sha256 = "sha256-qORKaqpLVPIB5t1JtClP3Ey8yBTKY46YsMIc/fGV688=";
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

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-notes-plugin";
    description = "Sticky notes plugin for Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
