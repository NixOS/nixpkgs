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
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "PhilipJohnBasile";
    repo = "vecstore";
    rev = "v0.0.1";
    hash = "sha256-fd94c51d68988ae3fe7e50e572978e10fdd5aba267e9a90cd136a0cb561c1412";
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
    description = "Embeddable vector database (alpha) with HNSW search and RAG tooling";
    homepage = "https://github.com/PhilipJohnBasile/vecstore";
    license = licenses.mit;
    maintainers = with maintainers; [ philipjohnbasile ];
    mainProgram = "vecstore-server";
    platforms = platforms.unix;
  };
}
