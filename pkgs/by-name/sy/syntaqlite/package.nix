{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syntaqlite";
  version = "0.5.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LalitMaganti";
    repo = "syntaqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9qBClpw7vQhHJ70J4GRtmc0D7oQZgaQ6Mcp/3J9Far8=";
  };

  cargoHash = "sha256-zEE83vIsxlkTUMJWBU4HY5Qg98A8P2POrqE+tCI4hno=";

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
