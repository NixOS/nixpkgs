{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  glib,
  gtk3,
  gtksourceview4,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-notes-plugin";
  version = "1.12.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-notes-plugin";
    tag = "xfce4-notes-plugin-${finalAttrs.version}";
    hash = "sha256-q8XQSLhnD7rnRfmNEunc4rKpFSWg9Ja4W7fs5lrnhZ0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
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

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-notes-plugin-"; };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-notes-plugin";
    description = "Sticky notes plugin for Xfce panel";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
