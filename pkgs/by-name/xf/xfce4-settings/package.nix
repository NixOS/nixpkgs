{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  wayland-scanner,
  wrapGAppsHook3,
  xfce4-exo,
  garcon,
  gtk3,
  gtk-layer-shell,
  glib,
  libnotify,
  libX11,
  libXext,
  libxfce4ui,
  libxfce4util,
  libxklavier,
  withXrandr ? true,
  upower,
  # Disabled by default on upstream and actually causes issues:
  # https://gitlab.xfce.org/xfce/xfce4-settings/-/issues/222
  withUpower ? false,
  wlr-protocols,
  xfconf,
  xf86inputlibinput,
  colord,
  withColord ? true,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-settings";
  version = "4.20.2";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-settings";
    tag = "xfce4-settings-${finalAttrs.version}";
    hash = "sha256-hx1ilXPcwWWDwNR/k2b+9vR5aCv9UlPR0d42OE6JxEk=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    xfce4-dev-tools
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    xfce4-exo
    garcon
    glib
    gtk3
    gtk-layer-shell
    libnotify
    libX11
    libXext
    libxfce4ui
    libxfce4util
    libxklavier
    wlr-protocols
    xf86inputlibinput
    xfconf
  ]
  ++ lib.optionals withUpower [ upower ]
  ++ lib.optionals withColord [ colord ];

  configureFlags = [
    "--enable-maintainer-mode"
    "--enable-pluggable-dialogs"
    "--enable-sound-settings"
    (lib.enableFeature withXrandr "xrandr")
  ]
  ++ lib.optionals withUpower [ "--enable-upower-glib" ]
  ++ lib.optionals withColord [ "--enable-colord" ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "xfce4-settings-";
    odd-unstable = true;
  };

  meta = {
    description = "Settings manager for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/xfce4-settings";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-settings-manager";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
