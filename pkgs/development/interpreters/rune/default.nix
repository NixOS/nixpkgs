{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rune";
  version = "0.13.2";

  src = fetchCrate {
    pname = "rune-cli";
    inherit version;
    hash = "sha256-Xk4gUBxDdnW2AIEvMaEjzVsqCQFK9B/Wyg7RpJ/hbrA=";
  };

  cargoHash = "sha256-hpJ++mzP2QFE/iHZQvcjT03xPnyPYw7EgsL8NwxrZVQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
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
