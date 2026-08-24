{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemctl-tui";
  version = "0.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rgwood";
    repo = "systemctl-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vsllvCDHQy9EH0X1RRp5N3DISTrWFi6rywUp3wL42ks=";
  };

  cargoHash = "sha256-kb56IKlwPW5VMdFMz+6tgfqBTeqJbDECO2LXNAQleuI=";

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
