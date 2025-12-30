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
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  libyaml,
  xfconf,
  libnotify,
  garcon,
  gtk-layer-shell,
  thunar,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfdesktop";
  version = "4.20.1";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfdesktop";
    tag = "xfdesktop-${finalAttrs.version}";
    hash = "sha256-QBzsHXEdTGj8PlgB+L/TJjxAVksKqf+9KrRN3YaBf44=";
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
    libxfce4ui
    libxfce4util
    libxfce4windowing
    libyaml
    xfconf
    libnotify
    garcon
    gtk-layer-shell
    thunar
  ];

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "xfdesktop-";
    odd-unstable = true;
  };

  meta = {
    description = "Xfce's desktop manager";
    homepage = "https://gitlab.xfce.org/xfce/xfdesktop";
    mainProgram = "xfdesktop";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
