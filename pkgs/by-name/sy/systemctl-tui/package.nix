{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemctl-tui";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "rgwood";
    repo = "systemctl-tui";
    # https://github.com/rgwood/systemctl-tui/issues/68#issuecomment-3735677971
    tag = "v${finalAttrs.version}-take2";
    hash = "sha256-6SN8c8gDVsvFFyrcFjdO70pJpVxWG/AbdB6V4mM5Q5Y=";
  };

  cargoHash = "sha256-4VlKJUxmxC1dIZYsUMLhNzOJTYacpddlKZUSwjKlzJ8=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script;
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
