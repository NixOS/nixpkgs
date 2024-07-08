{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rune";
  version = "0.13.3";

  src = fetchCrate {
    pname = "rune-cli";
    inherit version;
    hash = "sha256-nrHduxHSX31nwqcBbgPT4WH64LXTruScocpqex4zxf4=";
  };

  cargoHash = "sha256-EjUzXb2r6lKV1fBL7KdseC9vmW2L0AjpowYo4j8Xpv8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    RUNE_VERSION = version;
  };

  meta = with lib; {
    description = "Interpreter for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://rune-rs.github.io/";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rune";
  };
}
