{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  librsvg,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  dbus-glib,
  libepoxy,
  gtk3,
  libxdamage,
  libstartup_notification,
  libxfce4ui,
  libxfce4util,
  libwnck,
  libxpresent,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfwm4";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfwm4";
    tag = "xfwm4-${finalAttrs.version}";
    hash = "sha256-5UZQrAH0oz+G+7cvXCLDJ4GSXNJcyl4Ap9umb7h0f5Q=";
  };

  nativeBuildInputs = [
    gettext
    librsvg # rsvg-convert
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    libepoxy
    gtk3
    libxdamage
    libstartup_notification
    libxfce4ui
    libxfce4util
    libwnck
    libxpresent
    xfconf
  ];

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "xfwm4-";
    odd-unstable = true;
  };

  meta = {
    description = "Window manager for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/xfwm4";
    mainProgram = "xfwm4";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
