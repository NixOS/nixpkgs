{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syntaqlite";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LalitMaganti";
    repo = "syntaqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fuMcrNgt/gOsAPrc9CDuXH25JVIXzgDdAtDLIfwBEuo=";
  };

  cargoHash = "sha256-AqYo4u/cQd3F4qTE2V0WETRT49FhW9mozr3vjFHxSd8=";

  # CLI contains MCP and LSP
  buildAndTestSubdir = "syntaqlite-cli";

  buildFeatures = [ "default" ];

  # Some integration tests require a live SQLite database or network access
  checkFlags = [
    "--skip=integration"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast, accurate SQLite SQL formatter, validator, and language server — built on SQLite's own grammar";
    homepage = "https://syntaqlite.com";
    changelog = "https://github.com/LalitMaganti/syntaqlite/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "syntaqlite";
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
