{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  cairo,
  glib,
  gtk3,
  gtk-layer-shell,
  libX11,
  libXi,
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  xfce4-panel,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-docklike-plugin";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-docklike-plugin";
    tag = "xfce4-docklike-plugin-${finalAttrs.version}";
    hash = "sha256-1R9qQKqn/CIV36GYmyg54t3xiY23qUs5EMLxvAIavK8=";
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
  ];

  buildInputs = [
    cairo
    glib
    gtk3
    gtk-layer-shell
    libX11
    libXi
    libxfce4ui
    libxfce4util
    libxfce4windowing
    xfce4-panel
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-docklike-plugin-"; };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start";
    description = "Modern, minimalist taskbar for Xfce";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
