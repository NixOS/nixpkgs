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
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "sectore";
    repo = "timr-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s2FnMwDq4tYBaWaT9y1GLbVGFs7zSnOmjcF5leO12JE=";
  };

  cargoHash = "sha256-9yd348QGjFxt+QmEBuYzd612mFm/PyETrZy4z5wW+nI=";

  # Enable upstream "sound" feature when requested
  buildFeatures = lib.optionals enableSound [ "sound" ];

  nativeBuildInputs = lib.optionals (enableSound && stdenv.isLinux) [ pkg-config ];

  # Runtime/FFI deps for the sound feature (Linux)
  buildInputs = lib.optionals (enableSound && stdenv.isLinux) [
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
    description = "TUI to organize your time: Pomodoro, Countdown, Timer";
    homepage = "https://github.com/sectore/timr-tui";
    changelog = "https://github.com/sectore/timr-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "timr-tui";
    maintainers = [ lib.maintainers.flokkq ];
    platforms = lib.platforms.unix;
  };
})
