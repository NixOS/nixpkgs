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
  version = "2026.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "webstonehq";
    repo = "tuxedo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E7zjvg5EMBq9hDjILKsNHb7ig90DcS28x/db8v0b5x0=";
  };

  cargoHash = "sha256-UpSIqUA+mJe31m2Oo6P1ZXvV9+fi90fUYg7OWWts2Js=";

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
