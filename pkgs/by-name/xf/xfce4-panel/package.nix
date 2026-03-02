{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  python3,
  xfce4-dev-tools,
  wrapGAppsHook3,
  cairo,
  xfce4-exo,
  garcon,
  gtk-layer-shell,
  gtk3,
  libdbusmenu-gtk3,
  libwnck,
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  tzdata,
  wayland,
  xfconf,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  vala,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-panel";
  version = "4.20.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-panel";
    tag = "xfce4-panel-${finalAttrs.version}";
    hash = "sha256-yfiF+ciuRNJzBt3n1rH2ywA1vNGYRVHu2ojf/EIGwyg=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    python3
    xfce4-dev-tools
    wrapGAppsHook3
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [
    cairo
    xfce4-exo
    garcon
    gtk-layer-shell
    libdbusmenu-gtk3
    libxfce4ui
    libxfce4windowing
    libwnck
    tzdata
    wayland
    xfconf
  ];

  propagatedBuildInputs = [
    gtk3
    libxfce4util
  ];

  postPatch = ''
    patchShebangs xdt-gen-visibility

    substituteInPlace plugins/clock/clock.c \
       --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "xfce4-panel-";
    odd-unstable = true;
  };

  meta = {
    description = "Panel for the Xfce desktop environment";
    homepage = "https://gitlab.xfce.org/xfce/xfce4-panel";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-panel";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
