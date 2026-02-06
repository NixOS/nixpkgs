{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  python3,
  cmake,
  libmysqlclient,
  makeBinaryWrapper,
  lib,
  nix-update-script,
  nixosTests,
}:

let
  pyFxADeps = python3.withPackages (p: [
    p.setuptools # imports pkg_resources
    # remainder taken from requirements.txt
    p.pyfxa
    p.tokenlib
    p.cryptography
  ]);
in

rustPlatform.buildRustPackage rec {
  pname = "syncstorage-rs";
  version = "0.21.1-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "syncstorage-rs";
    rev = "11659d98f9c69948a0aab353437ce2036c388711";
    hash = "sha256-G37QvxTNh/C3gmKG0UYHI6QBr0F+KLGRNI/Sx33uOsc=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    libmysqlclient
  ];

  preFixup = ''
    wrapProgram $out/bin/syncserver \
      --prefix PATH : ${lib.makeBinPath [ pyFxADeps ]}
  '';

  cargoHash = "sha256-9Dcf5mDyK/XjsKTlCPXTHoBkIq+FFPDg1zfK24Y9nHQ=";

  # almost all tests need a DB to test against
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  passthru.tests = { inherit (nixosTests) firefox-syncserver; };

  meta = {
    description = "Mozilla Sync Storage built with Rust";
    homepage = "https://github.com/mozilla-services/syncstorage-rs";
    changelog = "https://github.com/mozilla-services/syncstorage-rs/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "syncserver";
  };
}
