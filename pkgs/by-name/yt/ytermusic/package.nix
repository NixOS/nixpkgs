{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ytermusic";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ccgauche";
    repo = "ytermusic";
    tag = "beta-${version}";
    hash = "sha256-nu/vedQNs5TgCG1v5qwwDTnFTyXCS2KnLVrnEhCtzCs=";
  };

  cargoPatches = [
    # Fix compilation with Rust 1.80 (https://github.com/NixOS/nixpkgs/issues/332957)
    ./time-crate.patch
  ];

  cargoHash = "sha256-5KbqX8HU7s5ZLoCVUmZhvrliAl3wXV4/nMEI5tq2piU=";

  doCheck = true;

  cargoBuildType = "release";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    alsa-lib
    dbus
  ];

  meta = {
    description = "TUI based Youtube Music Player that aims to be as fast and simple as possible";
    homepage = "https://github.com/ccgauche/ytermusic";
    changelog = "https://github.com/ccgauche/ytermusic/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codebam ];
    mainProgram = "ytermusic";
  };
}
