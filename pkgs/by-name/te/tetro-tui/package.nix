{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tetro-tui";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "Strophox";
    repo = "tetro-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XLqwY0xee92zmN37GKoBt6to66DH4d3iXbBB8MtEO88=";
  };

  cargoHash = "sha256-OMg7fquP/svsSobCVWM3nJjkF6xszQsw3uMv5jQIWw4=";

  meta = {
    description = "Terminal game where tetrominos fall and stack";
    longDescription = ''
      Tetro TUI is a terminal-based tetromino-stacking game with cross-platform
      terminal rendering via Crossterm, extensive customization of gameplay and
      appearance, and replay recording.
    '';
    homepage = "https://github.com/Strophox/tetro-tui";
    changelog = "https://github.com/Strophox/tetro-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "tetro-tui";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
