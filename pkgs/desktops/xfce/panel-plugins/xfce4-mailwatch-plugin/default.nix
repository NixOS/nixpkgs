{
  lib,
  stdenv,
  fetchurl,
  gettext,
  meson,
  ninja,
  pkg-config,
  xfce4-panel,
  libxfce4ui,
  libxfce4util,
  exo,
  glib,
  gtk3,
  gnutls,
  libgcrypt,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-mailwatch-plugin";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/xfce4-mailwatch-plugin/${lib.versions.majorMinor finalAttrs.version}/xfce4-mailwatch-plugin-${finalAttrs.version}.tar.xz";
    hash = "sha256-XCEQJdsQlmY/prjMQSE0ZKbXHyTnYyZJnYV/+B6jhh8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libxfce4ui
    libxfce4util
    xfce4-panel
    exo
    glib
    gtk3
    gnutls
    libgcrypt
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-mailwatch-plugin";
    rev-prefix = "xfce4-mailwatch-plugin-";
  };

  meta = {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mailwatch-plugin";
    description = "Mail watcher plugin for Xfce panel";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
