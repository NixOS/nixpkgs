{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  polkit,
  xfce4-exo,
  libxfce4util,
  libxfce4ui,
  libxfce4windowing,
  xfconf,
  iceauth,
  gtk3,
  gtk-layer-shell,
  glib,
  libwnck,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-session";
  version = "4.20.3";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-session";
    tag = "xfce4-session-${finalAttrs.version}";
    hash = "sha256-HfVspmAkjuGgoI87VHNHFGZP17ZA0b31llY93gUtWxs=";
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
    gtk-layer-shell
    glib
    libxfce4ui
    libxfce4util
    libxfce4windowing
    libwnck
    xfconf
    polkit
    iceauth
  ];

  configureFlags = [
    "--enable-maintainer-mode"
    "--with-xsession-prefix=${placeholder "out"}"
    "--with-wayland-session-prefix=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  passthru = {
    xinitrc = "${finalAttrs.finalPackage}/etc/xdg/xfce4/xinitrc";
    updateScript = gitUpdater {
      rev-prefix = "xfce4-session-";
      odd-unstable = true;
    };
  };

  meta = {
    description = "Session manager for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/xfce4-session";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-session";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
