{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
}:

rustPlatform.buildRustPackage {
  pname = "tetro-tui";
  version = "1.1.0-unstable-2026-02-23";

  src = fetchFromGitHub {
    owner = "Strophox";
    repo = "tetro-tui";
    rev = "38adbc5d1e40336189b1ea9cc6145351600bc313";
    hash = "sha256-GLpleTJi/921va4zMeirNUbN1yTODIn7lnrwJMLTVnc=";
  };

  cargoHash = "sha256-9EFPtdy+usX7VBAPZ8i0mZizyeaxSyJeX7Smq/Qds7s=";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "tetro-tui";
      desktopName = "Tetro TUI";
      exec = "tetro-tui";
      terminal = true;
      comment = "A cross-platform terminal game where tetrominos fall and stack";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A cross-platform terminal game where tetrominos fall and stack";
    homepage = "https://github.com/Strophox/tetro-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gl1tchxd ];
    mainProgram = "tetro-tui";
  };
}
