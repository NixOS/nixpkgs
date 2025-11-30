{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  glib,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wrapGAppsHook3,
  exo,
  gtk3,
  gtk-layer-shell,
  libX11,
  libXext,
  libXfixes,
  libXtst,
  libxfce4ui,
  libxfce4util,
  wayland,
  wlr-protocols,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-screenshooter";
  version = "1.11.3";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-screenshooter";
    tag = "xfce4-screenshooter-${finalAttrs.version}";
    hash = "sha256-VN9j5Ieg3MZwhS4mE4LMRbQ5AM9F8O2n5lx/V0Qk0Po=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    exo
    gtk3
    gtk-layer-shell
    libX11
    libXext
    libXfixes
    libXtst
    libxfce4ui
    libxfce4util
    wayland
    wlr-protocols
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-screenshooter-"; };

  meta = {
    description = "Screenshot utility for the Xfce desktop";
    homepage = "https://gitlab.xfce.org/apps/xfce4-screenshooter";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-screenshooter";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
