{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "elm-test-rs";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "mpizenberg";
    repo = "elm-test-rs";
    tag = "v${version}";
    hash = "sha256-H9InR28T0PQjxqT99ojw8ey29tk79BPeXpkHL3VNnkU=";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  cargoHash = "sha256-Y3hqSw8SyU9uVE9jBsLV9bL5KzaB9pw96Yqy3Dvh4QA=";

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
