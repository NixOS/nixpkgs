{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-dict";
  version = "0.8.10";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-dict";
    tag = "xfce4-dict-${finalAttrs.version}";
    hash = "sha256-d/D6qcW3k2YsLJo5kohTOHLShHjofmHcR1Qfwe3ZFIk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-dict-"; };

  meta = {
    description = "Dictionary Client for the Xfce desktop environment";
    homepage = "https://gitlab.xfce.org/apps/xfce4-dict";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-dict";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
