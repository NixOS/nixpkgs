{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
stdenv.mkDerivation {
  pname = "wooz";

  # Using latest master, until at least https://github.com/negrel/wooz/issues/11 is resolved in some release after 0.1.0
  version = "0-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "negrel";
    repo = "wooz";
    rev = "cd8bc6092462d438f6497c016b7e79115c4b4723";
    hash = "sha256-ViAXu/13I4dTHWj7v10XVaOVXkf8682hPYyETzhGFzA=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Zoom / magnifier utility for wayland compositors";
    homepage = "https://github.com/negrel/wooz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
    platforms = lib.platforms.linux;
    mainProgram = "wooz";
  };
}
