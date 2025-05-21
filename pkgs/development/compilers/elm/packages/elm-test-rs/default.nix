{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "elm-test-rs";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "mpizenberg";
    repo = "elm-test-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-l3RV+j3wAQ88QGNXLILp7YiUpdk7bkN25Y723pDZw48=";
  };

  buildInputs =
    lib.optionals (!stdenv.isDarwin) [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreServices
      ]
    );

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pubgrub-dependency-provider-elm-0.1.0" = "sha256-00J5XZfmuB4/fgB06aaXrRjdmOpOsSwA3dC3Li1m2Cc=";
    };
  };
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
    ];
  };
}
