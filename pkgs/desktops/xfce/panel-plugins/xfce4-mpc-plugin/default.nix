{
  lib,
  stdenv,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  libmpd,
  libxfce4util,
  xfce4-panel,
  libxfce4ui,
  glib,
  gtk3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-mpc-plugin";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-mpc-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-mpc-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-3uW8wFZrotyVucO0yt1eizuyeYpUoqjYZScIkV/kXVA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libmpd
    libxfce4util
    libxfce4ui
    xfce4-panel
    glib
    gtk3
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-mpc-plugin";
    rev-prefix = "xfce4-mpc-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mpc-plugin";
    description = "MPD plugin for Xfce panel";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd0;
    teams = [ lib.teams.xfce ];
  };
})
