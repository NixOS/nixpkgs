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
  pcre2,
  xfce4-panel,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-verve-plugin";
  version = "2.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-verve-plugin";
    tag = "xfce4-verve-plugin-${finalAttrs.version}";
    hash = "sha256-mxSjYBeBc2HjdTFVdZSVdspAQTEyS+uQA6K17lJoLlc=";
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
    pcre2
    xfce4-panel
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-verve-plugin-"; };

  meta = {
    description = "Command-line plugin";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-verve-plugin";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
