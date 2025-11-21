{
  lib,
  fetchFromGitHub,
  gitUpdater,
  gtk3,
  libxkbcommon,
  meson,
  ninja,
  opencv,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
let
  pname = "wl-kbptr";
  version = "0.4.0";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "moverest";
    repo = "wl-kbptr";
    tag = "v${version}";
    hash = "sha256-4ZxiRlIcVpYT9AzMguqzuZ5p7lZbH/m7ZX839tsCgMU=";
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
    opencv
    pixman
    wayland
    wayland-protocols
  ];

  mesonFlags = [ "-Dopencv=enabled" ];

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
    maintainers = [
      lib.maintainers.luftmensch-luftmensch
      lib.maintainers.clementpoiret
    ];
    inherit (wayland.meta) platforms;
  };
}
