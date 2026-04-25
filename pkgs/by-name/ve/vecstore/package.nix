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
    rev = "v${version}";
    hash = "sha256-REPLACE_WITH_ACTUAL_HASH";
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
    maintainers = with maintainers; [ philipjohnbasile ];
    mainProgram = "vecstore-server";
    platforms = platforms.unix;
  };
}
