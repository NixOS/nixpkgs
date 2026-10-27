{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sdl3,
  openal,
  libsndfile,
  fluidsynth,
  alsa-lib,
  libxmp,
  libebur128,
  libspng,
  miniz,
  python3,
  yyjson,
  discord-rpc,
  nix-update-script,
  versionCheckHook,
  withDiscordRpc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "woof-doom";
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "woof";
    tag = "woof_${finalAttrs.version}";
    hash = "sha256-YiMLaAfMmLBLG5Zhl7hAhHVSWpUFUqH/CR4G3jwCFHk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    sdl3
    fluidsynth
    libsndfile
    libspng
    libxmp
    libebur128
    miniz
    openal
    yyjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optional withDiscordRpc discord-rpc;

  __structuredAttrs = true;
  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "WITH_DISCORD_RPC" withDiscordRpc)
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "woof_(.*)"
    ];
  };

  meta = {
    description = "Doom source port based on Boom/MBF";
    homepage = "https://github.com/fabiangreffrath/woof";
    changelog = "https://github.com/fabiangreffrath/woof/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "woof";
    platforms = lib.platforms.unix;
  };
})
