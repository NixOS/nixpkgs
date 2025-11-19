{
  lib,
  fetchFromGitHub,
  stdenv,
  wayland-scanner,
  wlr-protocols,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wl-clicker";
  version = "0.4";

  nativeBuildInputs = [ wayland-scanner ];
  buildInputs = [
    wlr-protocols
    wayland
  ];

  src = fetchFromGitHub {
    owner = "phoneticalb";
    repo = "wl-clicker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+k3iZOv12WbqpeYbYjIXBIB4mO2DrY1pl+MJn2B+cZA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install build/wl-clicker $out/bin/wl-clicker

    runHook postInstall
  '';

  meta = {
    description = "Wayland autoclicker";
    longDescription = "Script for auto clicking at incredibly high speeds - user must be a part of `input` group to run.";
    homepage = "https://github.com/phoneticalb/wl-clicker";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Flameopathic ];
    mainProgram = "wl-clicker";
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
})
