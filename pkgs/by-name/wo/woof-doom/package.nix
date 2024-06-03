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
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "woof-doom";
  version = "14.5.0";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "woof";
    rev = "woof_${finalAttrs.version}";
    hash = "sha256-LA4blTlee0+nRK066hj19Zm/FL2qhaZ9Y5JMfMj3IRU=";
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
