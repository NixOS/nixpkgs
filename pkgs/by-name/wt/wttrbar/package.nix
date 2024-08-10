{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-fuLKWooXn966RORH20D9wwbjNtyLEZOO8Y8RcjsFwqM=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [ Security SystemConfiguration ]);

  cargoHash = "sha256-Of1tHKIL2XbzA6YFxtvaP9sa+KMw8uJTFG0n84g2Eog=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
