{
  lib,
  stdenv,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  xfce4-panel,
  glib,
  gtk3,
  libgtop,
  libxfce4ui,
  libxfce4util,
  upower,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-systemload-plugin";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-systemload-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-systemload-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-bjY7z4RbuIMptShY1loexuANtRIa6SRuRusDE12VacY=";
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
    libgtop
    libxfce4ui
    libxfce4util
    upower
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-systemload-plugin";
    rev-prefix = "xfce4-systemload-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-systemload-plugin";
    description = "System load plugin for Xfce panel";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
