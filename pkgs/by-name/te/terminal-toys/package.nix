{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminal-toys";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Seebass22";
    repo = "terminal-toys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WIgi1rW2FH+WfHqloSXD2qbz9x8AWLm/wuucTY/jPHQ=";
  };

  cargoHash = "sha256-QgwDRVzIS/pc5wb/M6asl6yjERCdDqh4VuyYI0eL+3g=";

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
