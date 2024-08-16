{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
  alsa-lib,
  libiconv,
}:
rustPlatform.buildRustPackage rec {
  pname = "termusix";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "sumoduduk";
    repo = "termusix";
    rev = "v${version}";
    hash = "sha256-N8BdOYcMFadQnVn9rrgfSjfTN4RoNknGkwXQmepLo40=";
  };

  cargoHash = "sha256-s/bKh/vtkZl/2Mdp0Z/KOViKwumYmJ8MH0W8cy8nYPM=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreAudio
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.AudioUnit
      darwin.apple_sdk.frameworks.AudioToolbox
      darwin.apple_sdk.frameworks.Foundation
      libiconv
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
    ];

  doCheck = false;

  meta = with lib; {
    description = "A terminal-based music player with a user-friendly terminal UI, built with Rust";
    homepage = "https://github.com/sumoduduk/termusix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [sumoduduk];
    mainProgram = "termusix";
  };
}
