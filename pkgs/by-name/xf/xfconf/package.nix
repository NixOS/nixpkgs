{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  gobject-introspection,
  perl,
  pkg-config,
  vala,
  meson,
  ninja,
  python3,
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
  version = "4.21.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfconf";
    tag = "xfconf-${finalAttrs.version}";
    hash = "sha256-2WB392mViHRbi9FclnU1A+AW+iPGSpdWZVU9oBOvqlg=";
  };

  nativeBuildInputs = [
    gettext
    perl
    pkg-config
    meson
    ninja
    python3
    wrapGAppsNoGuiHook
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [ libxfce4util ];

  propagatedBuildInputs = [ glib ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

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
