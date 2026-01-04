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
  discord-rpc,
  nix-update-script,
  withDiscordRpc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "woof-doom";
  version = "15.3.0";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "woof";
    tag = "woof_${finalAttrs.version}";
    hash = "sha256-G9exAJivfZnT2eWQhFYT8ZVRUU1QT0VAZF1CDCXmJ04=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_net
    fluidsynth
    libsndfile
    libxmp
    libebur128
    openal
    yyjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optional withDiscordRpc discord-rpc;

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "WITH_DISCORD_RPC" withDiscordRpc)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Doom source port based on Boom/MBF";
    homepage = "https://github.com/fabiangreffrath/woof";
    changelog = "https://github.com/fabiangreffrath/woof/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "woof";
    platforms = lib.platforms.unix;
  };
})
