{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfconf,
  libwnck,
  libX11,
  libXmu,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-taskmanager";
  version = "1.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-taskmanager";
    tag = "xfce4-taskmanager-${finalAttrs.version}";
    hash = "sha256-HQsZ7SmOX8Z5yuQUe+AvQFx+HVWNRRHEO7dE5DnfT/8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
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
    xfconf
    libwnck
    libX11
    libXmu
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-taskmanager-"; };

  meta = {
    description = "Easy to use task manager for Xfce";
    homepage = "https://gitlab.xfce.org/apps/xfce4-taskmanager";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-taskmanager";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
