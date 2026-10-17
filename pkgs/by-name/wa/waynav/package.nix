{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  cairo,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waynav";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = "waynav";
    rev = finalAttrs.version;
    hash = "sha256-0bRVGJ1Go7lKg9iATNOsF2l1APsN4bVrkw5HAIGyw9g=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    cairo
  ];

  doCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Keyboard-driven grid mouse navigator for Wayland, a keynav rewrite";
    homepage = "https://github.com/kovetskiy/waynav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ali-abrar ];
    inherit (wayland.meta) platforms;
    mainProgram = "waynav";
  };
})
