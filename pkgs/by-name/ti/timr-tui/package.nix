{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib-with-plugins,
  alsa-plugins,
  pipewire,
  enableSound ? false,
}:
rustPlatform.buildRustPackage rec {
  pname = "timr-tui";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "sectore";
    repo = "timr-tui";
    rev = "v${version}";
    hash = "sha256-s2FnMwDq4tYBaWaT9y1GLbVGFs7zSnOmjcF5leO12JE=";
  };

  cargoHash = "sha256-3g86/+b1hpxphbxLYnx7Q/3P4QsRverTsOKPWWeAaXI=";

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

  meta = with lib; {
    description = "TUI to organize your time: Pomodoro, Countdown, Timer.";
    homepage = "https://github.com/sectore/timr-tui";
    changelog = "https://github.com/sectore/timr-tui/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "timr-tui";
    maintainers = with maintainers; [ flokkq ];
    platforms = platforms.unix;
  };
}
