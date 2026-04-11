{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemctl-tui";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "rgwood";
    repo = "systemctl-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r9bbEItk+DzVh6oFybaa8LZAAe35TyvvT6tuXOQlCSQ=";
  };

  cargoHash = "sha256-XLISZFxC3v0Hf0QX3P1HmrzACMBwFvB5hrAsZgYE7ig=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple TUI for interacting with systemd services and their logs";
    homepage = "https://crates.io/crates/systemctl-tui";
    changelog = "https://github.com/rgwood/systemctl-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siph ];
    mainProgram = "systemctl-tui";
  };
})
