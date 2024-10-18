{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage {
  pname = "tpi";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "turing-machines";
    repo = "tpi";
    rev = "v1.0.6";
    sha256 = "1ax43dbyy41awf7s5x6kcx96dwjl3d2iir1l3qdqlbw9g1ps8jmf";
  };

  cargoHash = "sha256-hSWDr1XuD6x96QV2QIdhGPQ00Sg7G5O5bkFNTdUx0ug=";

  meta = {
    description = "CLI tool to control your Turing Pi 2 board";
    homepage = "https://github.com/turing-machines/tpi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ WoutSwinkels ];
  };
}
