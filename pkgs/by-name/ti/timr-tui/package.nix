{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib-with-plugins,
  alsa-plugins,
  pipewire,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
  enableSound ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "timr-tui";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "sectore";
    repo = "timr-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZudyEkYAwVQ7Q61B7ElkwHBs9V36+aTOGgA+Rvr/F7Q=";
  };

  cargoHash = "sha256-1fGcVNjPs4UER9QVraUDX0twlm5hrbg7rzL7RjYZTEo=";

  # Enable upstream "sound" feature when requested
  buildFeatures = lib.optionals enableSound [ "sound" ];

  nativeBuildInputs = lib.optionals (enableSound && stdenv.hostPlatform.isLinux) [ pkg-config ];

  # Runtime/FFI deps for the sound feature (Linux)
  buildInputs = lib.optionals (enableSound && stdenv.hostPlatform.isLinux) [
    (alsa-lib-with-plugins.override {
      plugins = [
        alsa-plugins
        pipewire
      ];
    })
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  # Error: Operation not permitted (os error 1)
  versionCheckKeepEnvironment = lib.optionals stdenv.hostPlatform.isDarwin [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI to organize your time: Pomodoro, Countdown, Timer, Event";
    homepage = "https://github.com/sectore/timr-tui";
    changelog = "https://github.com/sectore/timr-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "timr-tui";
    maintainers = with lib.maintainers; [
      flokkq
      sectore
    ];
    platforms = lib.platforms.unix;
  };
})
