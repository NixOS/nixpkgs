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
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "syncstorage-rs";
    tag = version;
    hash = "sha256-UEBF0z2gn9Jpj6IefvB5XMwt21uuD5PlpHj7Ow7yf/Y=";
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

  cargoHash = "sha256-fkVqyA296BmK+jK9yJ0gj0V7CThv021AxNMCMFdr8fg=";

  # almost all tests need a DB to test against
  doCheck = false;

  passthru.updateScript = nix-update-script { };

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
