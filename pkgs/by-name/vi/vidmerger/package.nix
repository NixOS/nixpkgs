{
  lib,
  ffmpeg,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "vidmerger";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "TGotwig";
    repo = "vidmerger";
    rev = version;
    hash = "sha256-E3Y1UaYXl6NdCMM7IepqFzWNuHaMGLCN5BvQ/lxjFoc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Running cargo test -- . fails because it expects to have two mp4 files so that it can test the video merging functionalities
  doCheck = false;

  buildInputs = [
    ffmpeg
  ];

  meta = with lib; {
    description = "Merge video & audio files via CLI ";
    homepage = "https://github.com/TGotwig/vidmerger";
    license = with licenses; [
      mit
      commons-clause
    ];
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "vidmerger";
  };
}
