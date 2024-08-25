{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
  glib,
  granite7,
  gtk4,
  libadwaita,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-dock";
  version = "8.0.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = finalAttrs.version;
    hash = "sha256-Q4Y9FVqzPXoz2Nti1qB5SOJQ0tETPcv2fZPOMkJaND8=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    wayland
  ];

  meta = {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.pantheon.members;
    mainProgram = "io.elementary.dock";
  };
})
