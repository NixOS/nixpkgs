{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "elm-test-rs";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "mpizenberg";
    repo = "elm-test-rs";
    tag = "v${version}";
    hash = "sha256-NGonWCOLxON1lxsgRlWgY67TtIJYsLPXi96NcxF4Tso=";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  cargoHash = "sha256-qs6ujXl4j9gCEDQV5i47oa0eaqWZf4NqsVbNDsao5fI=";

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
