{
  stdenv,
  lib,
  fetchFromGitHub,
  glib,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  geoclue2,
  geocode-glib_2,
  granite7,
  gtk4,
  libadwaita,
  libshumate,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-maps";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "maps";
    rev = finalAttrs.version;
    hash = "sha256-ZXJp6LoR7+3v6Gqs2y04M/+UJN2CTpijHnJozd4fAls=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    geoclue2
    geocode-glib_2
    glib
    granite7
    gtk4
    libadwaita
    libshumate
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elementary/maps";
    description = "Map viewer designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.maps";
  };
})
