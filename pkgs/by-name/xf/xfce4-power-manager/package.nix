{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  wayland-scanner,
  xfce4-dev-tools,
  wrapGAppsHook3,
  gtk3,
  libnotify,
  libxfce4ui,
  libxfce4util,
  polkit,
  upower,
  wayland-protocols,
  wlr-protocols,
  xfconf,
  xfce4-panel,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-power-manager";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-power-manager";
    tag = "xfce4-power-manager-${finalAttrs.version}";
    hash = "sha256-qKUdrr+giLzNemhT3EQsOKTSiIx50NakmK14Ak7ZOCE=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    wayland-scanner
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    polkit
    upower
    wayland-protocols
    wlr-protocols
    xfconf
    xfce4-panel
  ];

  # using /run/current-system/sw/bin instead of nix store path prevents polkit permission errors on
  # rebuild.  See https://github.com/NixOS/nixpkgs/issues/77485
  postPatch = ''
    substituteInPlace common/xfpm-brightness-polkit.c --replace-fail "SBINDIR" "\"/run/current-system/sw/bin\""
    substituteInPlace src/xfpm-suspend.c --replace-fail "SBINDIR" "\"/run/current-system/sw/bin\""
  '';

  configureFlags = [
    "--enable-maintainer-mode"
    "--sbindir=\${out}/bin"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "xfce4-power-manager-";
    odd-unstable = true;
  };

  meta = {
    description = "Power manager for the Xfce Desktop Environment";
    homepage = "https://gitlab.xfce.org/xfce/xfce4-power-manager";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-power-manager";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
