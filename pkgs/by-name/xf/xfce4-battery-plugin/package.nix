{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-battery-plugin";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-battery-plugin";
    tag = "xfce4-battery-plugin-${finalAttrs.version}";
    hash = "sha256-I4x2QRYp6H5mR4J7nQ+VZ/T3r/dj4r4M9JbgN+oZHWQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-battery-plugin-"; };

  meta = {
    description = "Battery plugin for Xfce panel";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-battery-plugin";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
