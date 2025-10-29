{
  lib,
  ffmpeg,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vidmerger";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "TGotwig";
    repo = "vidmerger";
    tag = finalAttrs.version;
    hash = "sha256-N/iX0EN5R4oG4XHhpd/VaihrEHv5uT+grAJ6/KfSORE=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Running cargo test -- . fails because it expects to have two mp4 files so that it can test the video merging functionalities
  doCheck = false;

  buildInputs = [
    ffmpeg
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "Merge video & audio files via CLI";
    homepage = "https://github.com/TGotwig/vidmerger";
    license = with lib.licenses; [
      mit
      commons-clause
    ];
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "vidmerger";
  };
})
