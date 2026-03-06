{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tetro-tui";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Strophox";
    repo = "tetro-tui";
    rev = "v${version}";
    hash = "sha256-F2aYUt4S8gkXYr9DMcEzgF6RBjwvcqk5F5Q6IboCzeQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Terminal game where tetrominos fall and stack";
    longDescription = ''
      Tetro TUI is a Tetris-like terminal game featuring smooth rendering via
      the Crossterm library, compile-time modding system, and compressed replay
      functionality. Built with the Falling Tetromino Engine library.
    '';
    homepage = "https://github.com/Strophox/tetro-tui";
    changelog = "https://github.com/Strophox/tetro-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "tetro-tui";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
