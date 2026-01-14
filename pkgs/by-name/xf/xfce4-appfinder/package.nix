{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  garcon,
  gtk3,
  libxfce4util,
  libxfce4ui,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-appfinder";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-appfinder";
    tag = "xfce4-appfinder-${finalAttrs.version}";
    hash = "sha256-HovQnkfv5BOsRPowgMkMEWQmESkivVK0Xb7I15ZaOMc=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    garcon
    gtk3
    libxfce4ui
    libxfce4util
    xfconf
  ];

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "xfce4-appfinder-";
    odd-unstable = true;
  };

  meta = {
    description = "Appfinder for the Xfce4 Desktop Environment";
    homepage = "https://gitlab.xfce.org/xfce/xfce4-appfinder";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-appfinder";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
