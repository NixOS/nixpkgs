{
  fetchFromGitHub,
  git,
  lib,
  rustPlatform,
  rustfmt,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topcoat-cli";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "topcoat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1hdoCBRelS6FZV5qv/zYV64MpovCeAK1G/XezVFFfqs=";
  };

  cargoHash = "sha256-Dew2dgqeAOmnf0TkwRMMrdWuSS8o2KU05bb9O07C45E=";

  cargoBuildFlags = [
    "-p"
    "topcoat-cli"
  ];
  cargoTestFlags = [
    "-p"
    "topcoat-cli"
  ];

  nativeCheckInputs = [
    git
    rustfmt
  ];

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
