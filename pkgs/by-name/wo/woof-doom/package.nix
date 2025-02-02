{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_net,
  openal,
  libsndfile,
  fluidsynth,
  alsa-lib,
  libxmp,
  libebur128,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "woof-doom";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "woof";
    rev = "woof_${finalAttrs.version}";
    hash = "sha256-YLkQ2Hv+lO5wqFBqwmj0jwd/XHN3tj6fMh6x7c1PpMw=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_net
    alsa-lib
    fluidsynth
    libsndfile
    libxmp
    libebur128
    openal
  ];

  meta = {
    description = "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports";
    homepage = "https://github.com/fabiangreffrath/woof";
    changelog = "https://github.com/fabiangreffrath/woof/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "woof";
    platforms = with lib.platforms; darwin ++ linux ++ windows;
  };
})
