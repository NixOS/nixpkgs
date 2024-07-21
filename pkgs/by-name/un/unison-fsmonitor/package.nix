{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "unison-fsmonitor";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "autozimu";
    repo = "unison-fsmonitor";
    rev = "v${version}";
    hash = "sha256-U/KMKYqYVSeYBmW+PnXtvjnyUTjTJgtpwy1GPefqJOk=";
  };
  cargoHash = "sha256-eKRayFU3xq2uo6YeFqcTPLInZYlympH6Z01vOCVsVqQ=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  checkFlags = [
    # accesses /usr/bin/env
    "--skip=test_follow_link"
  ];

  meta = {
    homepage = "https://github.com/autozimu/unison-fsmonitor";
    description = "fsmonitor implementation for darwin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nevivurn ];
    platforms = lib.platforms.darwin;
    mainProgram = "unison-fsmonitor";
  };
}
