{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  accountsservice,
  exo,
  garcon,
  glib,
  gtk-layer-shell,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-whiskermenu-plugin";
  version = "2.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-whiskermenu-plugin";
    tag = "xfce4-whiskermenu-plugin-${finalAttrs.version}";
    hash = "sha256-2FACsP6mKx0k91xG3DaVS6hdvdLrjLu9Y9rVOW6PZ3M=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    exo
    garcon
    glib
    gtk-layer-shell
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-whiskermenu-plugin-"; };

  meta = {
    description = "Alternate application launcher for Xfce";
    mainProgram = "xfce4-popup-whiskermenu";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-whiskermenu-plugin";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
