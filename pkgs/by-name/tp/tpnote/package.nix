{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, cmake
, pkg-config
, oniguruma
, darwin
, installShellFiles
, tpnote
, testers
}:


rustPlatform.buildRustPackage rec {
  pname = "tpnote";
  version = "1.23.9";

  src = fetchFromGitHub {
    owner = "getreu";
    repo = "tp-note";
    rev = "v${version}";
    hash = "sha256-HOCd5N8oS8N+9alR3cG7IEghvhvcc8A+O24L6FD1F38=";
  };

  cargoHash = "sha256-T1AYiwGPolYUhJQzTyR7v5dqqNFUCSfSBzU3CithZPw=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
     AppKit
     CoreServices
     SystemConfiguration
  ]);

  RUSTONIG_SYSTEM_LIBONIG = true;

  passthru.tests.version = testers.testVersion { package = tpnote; };

  # The `tpnote` crate has no unit tests. All tests are in `tpnote-lib`.
  checkType = "debug";
  cargoTestFlags = "--package tpnote-lib";
  doCheck = true;

  meta = {
    changelog = "https://github.com/getreu/tp-note/releases/tag/v${version}";
    description = "Markup enhanced granular note-taking";
    homepage = "https://blog.getreu.net/projects/tp-note/";
    license = lib.licenses.mit;
    mainProgram = "tpnote";
    maintainers = with lib.maintainers; [ getreu ];
  };
}
