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
