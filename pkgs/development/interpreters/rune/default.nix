{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rune";
  version = "0.12.4";

  src = fetchCrate {
    pname = "rune-cli";
    inherit version;
    hash = "sha256-Fw6vCy6EMLzNbhwOUwCCsGSueDxfh7KMjLhhbvTzclc=";
  };

  cargoHash = "sha256-F1FI7ZVNXIFzxIzimq0KXtGNWw26x1eQyqv+hVYaS1E=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    RUNE_VERSION = version;
  };

  meta = with lib; {
    description = "An interpreter for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://rune-rs.github.io/";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rune";
  };
}
