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
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "syncstorage-rs";
    tag = version;
    hash = "sha256-WkUU6013sdLMh3hq9CE/D5+ftpdisihVD6W+FvjwbP4=";
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

  cargoHash = "sha256-V6shIxNpw+WHqypNgE02Sr7DO8l3H9tb72a1u2UHDfo=";

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
