{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuisky";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "sugyan";
    repo = "tuisky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7SkY2n5nfqGDxbaSYmWwwmksA8eNY9SjRLLfCUP3qtc=";
  };

  cargoHash = "sha256-rkIc/dRvuuOUq2v3bHLAL//DmiEBbBAhTxR0MHxAL/U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI client for bluesky";
    homepage = "https://github.com/sugyan/tuisky";
    changelog = "https://github.com/sugyan/tuisky/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tuisky";
  };
})
