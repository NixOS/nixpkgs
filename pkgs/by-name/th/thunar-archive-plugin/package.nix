{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  thunar,
  libxfce4util,
  gettext,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thunar-archive-plugin";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "thunar-plugins";
    repo = "thunar-archive-plugin";
    tag = "thunar-archive-plugin-${finalAttrs.version}";
    hash = "sha256-/WLkEqzFAKpB7z8mWSgufo4Qbj6KP3Ax8MWVZxIwDs0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    thunar
    glib
    gtk3
    libxfce4util
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "thunar-archive-plugin-"; };

  meta = {
    description = "Thunar plugin providing file context menus for archives";
    homepage = "https://gitlab.xfce.org/thunar-plugins/thunar-archive-plugin";
    license = lib.licenses.lgpl2Only;
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
