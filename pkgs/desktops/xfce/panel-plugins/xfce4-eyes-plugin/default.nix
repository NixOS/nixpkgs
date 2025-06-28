{
  lib,
  stdenv,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  libxfce4util,
  xfce4-panel,
  libxfce4ui,
  glib,
  gtk3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-eyes-plugin";
  version = "4.7.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-eyes-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-eyes-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-h/m5eMp1q7OqXtsTFetl75hlSmYsFGIYR93/6KpldK0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    glib
    gtk3
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-eyes-plugin";
    rev-prefix = "xfce4-eyes-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-eyes-plugin";
    description = "Rolling eyes (following mouse pointer) plugin for the Xfce panel";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
