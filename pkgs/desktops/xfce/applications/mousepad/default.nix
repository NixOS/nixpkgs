{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gspell,
  gtk3,
  gtksourceview4,
  libxfce4ui,
  xfconf,
  enablePolkit ? true,
  polkit,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mousepad";
  version = "0.6.5";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "mousepad";
    tag = "mousepad-${finalAttrs.version}";
    hash = "sha256-5ywpQY4KUnjFCLSAXQo3huzZf94YHK9SLmkkNtfx4Ho=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib # glib-compile-schemas
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gspell
    gtk3
    gtksourceview4
    libxfce4ui # for shortcut plugin
    xfconf # required by libxfce4kbd-private-3
  ]
  ++ lib.optionals enablePolkit [
    polkit
  ];

  # Use the GSettings keyfile backend rather than the default
  mesonFlags = [ "-Dkeyfile-settings=true" ];

  passthru.updateScript = gitUpdater { rev-prefix = "mousepad-"; };

  meta = {
    description = "Simple text editor for Xfce";
    homepage = "https://gitlab.xfce.org/apps/mousepad";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mousepad";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
