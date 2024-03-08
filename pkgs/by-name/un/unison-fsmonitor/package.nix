{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "unison-fsmonitor";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "autozimu";
    repo = "unison-fsmonitor";
    rev = "v${version}";
    hash = "sha256-JA0WcHHDNuQOal/Zy3yDb+O3acZN3rVX1hh0rOtRR+8=";
  };
  cargoHash = "sha256-aqAa0F1NSJI1nckTjG5C7VLxaLjJgD+9yK/IpclSMqs=";

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
