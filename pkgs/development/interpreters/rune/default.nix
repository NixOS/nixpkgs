{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rune";
  version = "0.13.1";

  src = fetchCrate {
    pname = "rune-cli";
    inherit version;
    hash = "sha256-7GScETlQ/rl9vOB9zSfsCM1ay1F5YV6OAxKe82lMU1I=";
  };

  cargoHash = "sha256-T6uYe+ZgXgsGN1714Ka+fxeVDoXgjVdfrrw5Rj/95cE=";

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
