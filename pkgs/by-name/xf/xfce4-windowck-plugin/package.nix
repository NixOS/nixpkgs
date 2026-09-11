{
  stdenv,
  lib,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  python3,
  glib,
  gtk3,
  libwnck,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-windowck-plugin";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-windowck-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-windowck-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-Ay4wXXTxe9ZbKL0mDPGS/PiqDfM9EWCH5IX9E2i3zzk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    glib
    gtk3
    libwnck
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin";
    rev-prefix = "xfce4-windowck-plugin-";
  };

  meta = {
    description = "Xfce panel plugin for displaying window title and buttons";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
