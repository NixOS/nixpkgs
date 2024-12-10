{ fetchFromGitHub
, rustPlatform
, pkg-config
, python3
, cmake
, libmysqlclient
, makeBinaryWrapper
, lib
, nix-update-script
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
  version = "0.17.15";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2o1QVDOgcVWvU0G8/dmVnxX4w5ZOZ9D8oh5GgO1ZpV0=";
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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "sentry-0.34.0" = "sha256-BdWz6EIEm2YU3DG3ODkuXCVCMV6srdyx2gXkOxINjHc=";
    };
  };

  # almost all tests need a DB to test against
  doCheck = false;

  passthru.updateScript = nix-update-script {};

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
