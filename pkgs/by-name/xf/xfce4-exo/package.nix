{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook_xsl,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  glib,
  libxslt,
  gtk3,
  libxfce4ui,
  libxfce4util,
  perl,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exo";
  version = "4.20.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "exo";
    tag = "exo-${finalAttrs.version}";
    hash = "sha256-mlGsFaKy96eEAYgYYqtEI4naq5ZSEe3V7nsWGAEucn0=";
  };

  nativeBuildInputs = [
    libxslt
    docbook_xsl
    gettext
    perl
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    libxfce4ui
    libxfce4util
  ];

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "exo-";
    odd-unstable = true;
  };

  meta = {
    description = "Application library for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/exo";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
