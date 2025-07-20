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
  libnotify,
  librsvg,
  libwnck,
  libxklavier,
  garcon,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-xkb-plugin";
  version = "0.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-xkb-plugin";
    tag = "xfce4-xkb-plugin-${finalAttrs.version}";
    hash = "sha256-yLlUKp7X8bylJs7ioQJ36mfqFlsiZXOgFXa0ZP7AG1E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    garcon
    glib
    gtk3
    libnotify
    librsvg
    libxfce4ui
    libxfce4util
    libxklavier
    libwnck
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-xkb-plugin-"; };

  meta = {
    description = "Allows you to setup and use multiple keyboard layouts";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-xkb-plugin";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
