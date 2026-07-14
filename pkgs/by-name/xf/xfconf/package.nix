{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  gobject-introspection,
  perl,
  pkg-config,
  vala,
  xfce4-dev-tools,
  wrapGAppsNoGuiHook,
  libxfce4util,
  glib,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfconf";
  version = "4.20.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfconf";
    tag = "xfconf-${finalAttrs.version}";
    hash = "sha256-U+Sk7ubBr1ZD1GLQXlxrx0NQdhV/WpVBbnLcc94Tjcw=";
  };

  nativeBuildInputs = [
    gettext
    perl
    pkg-config
    xfce4-dev-tools
    wrapGAppsNoGuiHook
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [ libxfce4util ];

  propagatedBuildInputs = [ glib ];

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "xfconf-";
    odd-unstable = true;
  };

  meta = {
    description = "Simple client-server configuration storage and query system for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/xfconf";
    mainProgram = "xfconf-query";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
