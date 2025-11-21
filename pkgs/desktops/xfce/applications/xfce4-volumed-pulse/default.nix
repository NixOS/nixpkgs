{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  libnotify,
  libpulseaudio,
  keybinder3,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-volumed-pulse";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-volumed-pulse";
    tag = "xfce4-volumed-pulse-${finalAttrs.version}";
    hash = "sha256-TdvqvlpNDs9i7IzegqGYTdvy2OVMdQUFvuENNmpkqAY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libnotify
    libpulseaudio
    keybinder3
    xfconf
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-volumed-pulse-"; };

  meta = {
    description = "Volume keys control daemon for Xfce using pulseaudio";
    homepage = "https://gitlab.xfce.org/apps/xfce4-volumed-pulse";
    mainProgram = "xfce4-volumed-pulse";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
