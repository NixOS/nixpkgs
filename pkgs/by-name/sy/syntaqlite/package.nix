{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syntaqlite";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "LalitMaganti";
    repo = "syntaqlite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v+QRu8fgafryp4jN9lAxZybe6r1MKRxn0xolx9GYKXA=";
  };

  cargoHash = "sha256-BldZR7ElAwp1OVk0D22Y/+vyFz+eR/+EoGihqHLzEOg=";

  cargoBuildFlags = [
    "--package"
    "syntaqlite-cli"
  ];

  cargoTestFlags = [
    "--package"
    "syntaqlite-cli"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Fast, accurate SQLite SQL formatter, validator, and language server — built on SQLite's own grammar";
    homepage = "https://syntaqlite.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "syntaqlite";
  };
})
