{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syntaqlite";
  version = "0.12.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LalitMaganti";
    repo = "syntaqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KdzaKjSvaoLWnxTBmNd8CDvPcCjY50hGWAJ1hkxldFc=";
  };

  cargoHash = "sha256-tT6HM4R6P2C2zybkpOhvnHJS3OweI8cEeT7UzR4qlxc=";

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
