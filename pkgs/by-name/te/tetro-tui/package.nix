{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal-based tetromino-stacking game";
    homepage = "https://github.com/Strophox/tetro-tui";
    changelog = "https://github.com/Strophox/tetro-tui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yarn ];
    mainProgram = "tetro-tui";
  };
})
