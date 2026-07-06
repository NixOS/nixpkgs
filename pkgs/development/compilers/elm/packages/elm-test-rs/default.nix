{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "elm-test-rs";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mpizenberg";
    repo = "elm-test-rs";
    tag = "v${version}";
    hash = "sha256-Rp+yA2keuw2YRwMQeJEk5FANk6XB8ZWFNCj+7k19Y84=";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  cargoHash = "sha256-sJaeTs7Hbys0j+QIT6Zm74E5M6J/zK43u4P8gSfS/jE=";

  # Tests perform networking and therefore can't work in sandbox
  doCheck = false;

  meta = {
    description = "Fast and portable executable to run your Elm tests";
    mainProgram = "elm-test-rs";
    homepage = "https://github.com/mpizenberg/elm-test-rs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      jpagex
      zupo
      turbomack
    ];
  };
}
