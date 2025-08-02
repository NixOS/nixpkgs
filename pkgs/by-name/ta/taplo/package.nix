{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  withLsp ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.10.0";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    hash = "sha256-iKc4Nu7AZE1LSuqXffi3XERbOqZMOkI3PV+6HaJzh4c=";
  };

  cargoHash = "sha256-tvijtB5fwOzQnnK/ClIvTbjCcMeqZpXcRdWWKZPIulM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  buildFeatures = lib.optional withLsp "lsp";

  meta = {
    description = "TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
