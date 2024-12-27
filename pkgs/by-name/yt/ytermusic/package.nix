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
    rev = "beta-${version}";
    hash = "sha256-nu/vedQNs5TgCG1v5qwwDTnFTyXCS2KnLVrnEhCtzCs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rusty_ytdl-0.6.6" = "sha256-htXD8v9Yd7S0iLjP6iZu94tP5KO5vbmkdUybqA7OtlU=";
      "symphonia-0.5.4" = "sha256-uf0BbpqtlpZhsnV7Cm8egxjb/fXSINsOANTjDUQ4U9M=";
    };
  };
  postPatch = "cp ${./Cargo.lock} Cargo.lock";

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
    changelog = "https://github.com/ccgauche/ytermusic/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codebam ];
    mainProgram = "ytermusic";
  };
}
