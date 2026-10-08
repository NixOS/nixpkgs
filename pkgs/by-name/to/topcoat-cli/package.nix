{
  fetchFromGitHub,
  lib,
  rustPlatform,
  rustfmt,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topcoat-cli";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "topcoat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rbZlsfBHwVqzlzI0TRD7Uq8ril3guyFPCj6UNUnaz68=";
  };

  cargoHash = "sha256-1DHepVBNTPAC/fcxMwUGNXJm4ue5cWsczt14gSHUITc=";

  cargoBuildFlags = [
    "-p"
    "topcoat-cli"
  ];
  cargoTestFlags = [
    "-p"
    "topcoat-cli"
  ];

  nativeCheckInputs = [ rustfmt ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI for Topcoat, a modular, batteries-included Rust web framework for server-rendered apps";
    homepage = "https://github.com/tokio-rs/topcoat";
    changelog = "https://github.com/tokio-rs/topcoat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "topcoat";
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})
