{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libsixel,
  withSixel ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    tag = "v${version}";
    hash = "sha256-dI/o8gcl9s+p/8ECtgo136DMR5FkLddpdUj6uurLj04=";
  };

  # tests need an interactive terminal
  doCheck = false;

  cargoHash = "sha256-JAQTW/7qhQCEqleKLOP4Gi9GKX+nVqQkAwlEZxVP9ps=";

  buildFeatures = lib.optional withSixel "sixel";
  buildInputs = lib.optional withSixel libsixel;

  meta = {
    description = "Command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chuangzhu
      sigmanificient
    ];
    mainProgram = "viu";
  };
}
