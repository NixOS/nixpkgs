{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tetro-tui";
  version = "3.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Strophox";
    repo = "tetro-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i/d+i6E0ClMAAjC6zB9Lt26LYEcjvR01MCzGne2EXNQ=";
  };

  cargoHash = "sha256-LTHokF9T7nRvvzfQWSL9igTHmvV+w40Pm4z/i0y7goA=";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "tetro-tui";
      desktopName = "Tetro TUI";
      exec = "tetro-tui";
      terminal = true;
      comment = "Cross-platform terminal game where tetrominos fall and stack";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform terminal game where tetrominos fall and stack";
    homepage = "https://github.com/Strophox/tetro-tui";
    changelog = "https://github.com/Strophox/tetro-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ gl1tchxd ];
    mainProgram = "tetro-tui";
  };
})
