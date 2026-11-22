{
  stdenv,
  lib,
  fetchFromGitHub,
  gettext,
  gtk3,
  libx11,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xenity";
  version = "3.44.6";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "xenity";
    tag = finalAttrs.version;
    hash = "sha256-X1blrZghuvwjitYxORVHogZ4qRAc3pLonDBt0xY6NUg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libx11
  ];

  meta = {
    description = "Drop-in replacement for Zenity 3.44 (GTK3)";
    homepage = "https://github.com/xapp-project/xenity";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "xenity";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
