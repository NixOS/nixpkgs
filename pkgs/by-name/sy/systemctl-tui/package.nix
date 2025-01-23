{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "rgwood";
    repo = "systemctl-tui";
    tag = "v${version}";
    hash = "sha256-7I4PM4ZQVtDESfchX0/HGu0Y94BxMCLNIrPw8bSokCQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bnnqGWX7xA4+55qDY7hzimVDPKaVD4sX//tk8Tgkqkc=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script;
  };

  meta = {
    description = "Simple TUI for interacting with systemd services and their logs";
    homepage = "https://crates.io/crates/systemctl-tui";
    changelog = "https://github.com/rgwood/systemctl-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siph ];
    mainProgram = "systemctl-tui";
  };
}
