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

  meta = with lib; {
    description = "TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
