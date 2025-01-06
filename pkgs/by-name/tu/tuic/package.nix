{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuic";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "EAimTY";
    repo = pname;
    rev = "tuic-server-${version}";
    hash = "sha256-VoNr91vDqBlt9asT/dwCeYk13UNiDexNNiKwD5DSn8k=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Security
    ]
  );

  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  # doc test will fail in this version
  checkFlags = [ "--skip=lib" ];

  meta = {
    homepage = "https://github.com/EAimTY/tuic";
    description = "Delicately-TUICed 0-RTT proxy protocol";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ oluceps ];
  };
}
