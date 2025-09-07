{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "tpi";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "turing-machines";
    repo = "tpi";
    rev = "v${version}";
    hash = "sha256-se5+8Zf+RKtvfkmDDxKiUVp5J+bQ9j9RFedDK/pxCgA=";
  };

  cargoHash = "sha256-neXFAMeo/LG3beNoR9q2gAZhlNrk0T4A5IdqR2cZocs=";

  meta = {
    description = "CLI tool to control your Turing Pi 2 board";
    homepage = "https://github.com/turing-machines/tpi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ WoutSwinkels ];
    mainProgram = "tpi";
  };
}
