{
  lib,
  fetchFromGitHub,
  gitUpdater,
  gtk3,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
let
  pname = "wl-kbptr";
  version = "0.2.3";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "moverest";
    repo = "wl-kbptr";
    rev = "refs/tags/v${version}";
    hash = "sha256-4OWy5Q+NSKgzDn12aflZ+YAfacLeOTIhOojiJ2WiqQg=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    gtk3
    libxkbcommon
    wayland
    wayland-protocols
  ];

  strictDeps = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "https://github.com/moverest/wl-kbptr";
    description = "Control the mouse pointer with the keyboard on Wayland";
    changelog = "https://github.com/moverest/wl-kbptr/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    mainProgram = "wl-kbptr";
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    inherit (wayland.meta) platforms;
  };
}
