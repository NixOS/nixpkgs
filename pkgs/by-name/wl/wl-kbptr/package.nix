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
}:
let
  pname = "wl-kbptr";
  version = "0.2.1";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "moverest";
    repo = "wl-kbptr";
    rev = "refs/tags/v${version}";
    hash = "sha256-bA4PbWJNM4qWDF5KfNEgeQ5Z/r/Aw3wL8YUMSnzUo0w=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
