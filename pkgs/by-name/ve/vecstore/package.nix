{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "vecstore";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "PhilipJohnBasile";
    repo = "vecstore";
    rev = "v1.0.0";
    hash = "sha256-96bce955be4d16ccd29e6dbd8bbfe87c1da869b4c76607176ad7ca9c54895448";
  };

  cargoHash = "sha256-REPLACE_WITH_ACTUAL_CARGO_HASH";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  buildFeatures = [ "server" ];

  # Build only the server binary
  cargoBuildFlags = [ "--bin" "vecstore-server" ];

  meta = with lib; {
    description = "High-performance embeddable vector database (100/100 feature matrix vs competitors) - HNSW, hybrid search, multi-language, production-ready";
    homepage = "https://github.com/PhilipJohnBasile/vecstore";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "vecstore-server";
    platforms = platforms.unix;
  };
}
