{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  xfce4-exo,
  gtk3,
  libgudev,
  libxfce4ui,
  libxfce4util,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thunar-volman";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "thunar-volman";
    tag = "thunar-volman-${finalAttrs.version}";
    hash = "sha256-XIVs/vRwy3QJQW/U7eLBvGdzplWlhdxn3f1lyTQsmpE=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    xfce4-exo
    gtk3
    libgudev
    libxfce4ui
    libxfce4util
    xfconf
  ];

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "thunar-volman-";
    odd-unstable = true;
  };

  meta = {
    description = "Thunar extension for automatic management of removable drives and media";
    homepage = "https://gitlab.xfce.org/xfce/thunar-volman";
    license = lib.licenses.gpl2Plus;
    mainProgram = "thunar-volman";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
