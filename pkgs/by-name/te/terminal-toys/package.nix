{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminal-toys";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Seebass22";
    repo = "terminal-toys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-42NaTYEerkhexsmG6WEaC9uEC+YCJsShVlAsQFT4eJ0=";
  };

  cargoHash = "sha256-/L0JQDyjn5xuWIrx4EM2+uTbQt6uuOTHE27xfhmUjjY=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Screensavers for your terminal";
    homepage = "https://github.com/Seebass22/terminal-toys";
    changelog = "https://github.com/Seebass22/terminal-toys/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "terminal-toys";
  };
})
