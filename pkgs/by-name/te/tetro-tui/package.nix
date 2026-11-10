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
  version = "3.6.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Strophox";
    repo = "tetro-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tlZYvk9PrdkuN8m+tu/sPrG88k9L58T/QDk2fLZmM34=";
  };

  cargoHash = "sha256-AF5aerbBhBJ8Ommrq27GjSeGE/smTvVdEoXS1XLktRE=";

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
