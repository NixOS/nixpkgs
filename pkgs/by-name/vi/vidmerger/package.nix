{ lib
, ffmpeg
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "vidmerger";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "TGotwig";
    repo = "vidmerger";
    rev = version;
    hash = "sha256-TnVDbhMPBByuhXNuKiyhq6wD3XZgp8nGtIf+7XkVmw8=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Running cargo test -- . fails
  doCheck = false;

  buildInputs = [
    ffmpeg
  ];
  meta = with lib; {
    description = "Merge video & audio files via CLI ";
    homepage = "https://github.com/TGotwig/vidmerger";
    license = licenses.free;
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "vidmerger";
  };
}
