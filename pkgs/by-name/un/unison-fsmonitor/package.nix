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
  cargoHash = "sha256-i5FRTdilY1T25KefZjVS2aVQjfH6KrvO0c4Wwes6zYQ=";

  checkFlags = [
    # accesses /usr/bin/env
    "--skip=test_follow_link"
  ];

  meta = with lib; {
    homepage = "https://github.com/autozimu/unison-fsmonitor";
    description = "fsmonitor implementation for darwin";
    license = licenses.mit;
    maintainers = with maintainers; [ nevivurn ];
    platforms = platforms.darwin;
    mainProgram = "unison-fsmonitor";
  };
}
