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
  pname = "xfce4-timer-plugin";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-timer-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-timer-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-HTrDqixDRUAMAlZCd452Q6q0EEdiK6+c3AC7rHjon5k=";
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
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-timer-plugin";
    rev-prefix = "xfce4-timer-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-timer-plugin";
    description = "Simple countdown and alarm plugin for the Xfce panel";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.xfce ];
  };
})
