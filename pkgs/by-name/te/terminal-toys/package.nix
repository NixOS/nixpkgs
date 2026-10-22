{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminal-toys";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Seebass22";
    repo = "terminal-toys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OIzVs09tUYQu5NQyNMx+3bkHJe733yYmHQ/pW0oZzSQ=";
  };

  cargoHash = "sha256-RGxVyqBxM6LBycdzKdp6Vm/KlZaPZgLsQovamBLzex8=";

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
