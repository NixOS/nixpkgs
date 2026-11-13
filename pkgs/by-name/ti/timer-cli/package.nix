{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timer-cli";
  version = "0-unstable-2026-11-13";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "eon5942";
    repo = "timer";
    rev = "3cf58f343e008edbc4f48c11ae59d601850394e0";
    hash = "sha256-sV6faACVC4ULYhhxeTww9bo2fdMF9fZXXc8GP4YEeM0=";
  };

  buildPhase = "${stdenv.cc.targetPrefix}c++ -O2 -o timer timer.cpp";
  installPhase = "install -Dm755 timer $out/bin/timer";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Linux CLI timer made in C++";
    homepage = "https://github.com/eon5942/timer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eon5942 ];
    mainProgram = "timer";
    platforms = lib.platforms.linux;
  };
})
