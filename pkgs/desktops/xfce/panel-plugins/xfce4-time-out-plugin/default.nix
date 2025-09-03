{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  libX11,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-time-out-plugin";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-time-out-plugin";
    tag = "xfce4-time-out-plugin-${finalAttrs.version}";
    hash = "sha256-hyeqSnynsjAeD67oPjQs0ZeLKreXFMZXmvu38zweqrE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    libX11
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-time-out-plugin-"; };

  meta = {
    description = "Panel plug-in to take periodical breaks from the computer";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-time-out-plugin";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
