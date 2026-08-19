{
  lib,
  rustPlatform,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuxedo";
  version = "2026.7.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "webstonehq";
    repo = "tuxedo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4tkKjFQN6giCBVOs8K/EjGFAG73CWtPGC4e8YPpxFEs=";
  };

  cargoHash = "sha256-jkrxG7KyAUStyZonAZbgRPkEnElpzYrCDdvCkb2cW2A=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  checkFlags = [
    # Failure
    "--skip=insert_dialog_after_nl_parse"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "fast, keyboard-driven terminal UI for todo.txt";
    homepage = "https://github.com/webstonehq/tuxedo";
    changelog = "https://github.com/webstonehq/tuxedo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iogamaster ];
    mainProgram = "tuxedo";
  };
})
