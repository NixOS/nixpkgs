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
  yyjson,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "woof-doom";
  version = "15.0.1";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "woof";
    rev = "woof_${finalAttrs.version}";
    hash = "sha256-B1pcozy6ZyJkrrxnoL4tXSlb/VzZ9NoSPub8OVVorXo=";
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
    yyjson
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports";
    homepage = "https://github.com/fabiangreffrath/woof";
    changelog = "https://github.com/fabiangreffrath/woof/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ keenanweaver ];
    mainProgram = "woof";
    platforms = with platforms; darwin ++ linux ++ windows;
  };
})
