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
    tag = "v${version}";
    hash = "sha256-l3RV+j3wAQ88QGNXLILp7YiUpdk7bkN25Y723pDZw48=";
  };

  buildInputs =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreServices
      ]
    );

  useFetchCargoVendor = true;
  cargoHash = "sha256-F3/v4zYGZRv1PRVl/Tas+e0pc/dTM6ina+/c63KVuZY=";

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
