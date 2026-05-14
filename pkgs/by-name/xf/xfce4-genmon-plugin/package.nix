{
  lib,
  stdenv,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  libxfce4util,
  xfce4-panel,
  xfconf,
  libxfce4ui,
  glib,
  gtk3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-genmon-plugin";
  version = "4.3.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-genmon-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-genmon-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-B3GXkR2E5boi57uJXObAONu9jo4AZ+1vTkhQK3FnooI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    xfconf
    glib
    gtk3
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-genmon-plugin";
    rev-prefix = "xfce4-genmon-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin";
    description = "Generic monitor plugin for the Xfce panel";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
