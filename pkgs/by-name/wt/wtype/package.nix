{
  lib,
  stdenv,
  fetchFromGitHub,

  meson,
  ninja,
  pkg-config,

  libxkbcommon,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wtype";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wtype";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1Qf35RPfaMusP1WeLcwmvfmnCmaG/WZBoIlOewZakc4=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    libxkbcommon
    wayland
  ];

  meta = {
    description = "xdotool type for wayland";
    homepage = "https://github.com/atx/wtype";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ justinlovinger ];
    mainProgram = "wtype";
  };
})
