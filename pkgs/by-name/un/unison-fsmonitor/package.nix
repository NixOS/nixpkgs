{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "unison-fsmonitor";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "autozimu";
    repo = "unison-fsmonitor";
    rev = "v${version}";
    hash = "sha256-1W05b9s0Pg2LzNu0mFo/JKpPw0QORqZkXhbbSuCZIUo=";
  };

  cargoHash = "sha256-FhENsOGv4jN9A0HS0TIPJMiXA4mYBL668jyckVNGOKc=";

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
