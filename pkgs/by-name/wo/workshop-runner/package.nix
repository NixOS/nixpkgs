{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "workshop-runner";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "rust-workshop-runner";
    rev = "v${version}";
    hash = "sha256-2lt4RloIRnFvWZ+HeZx7M2cg/wHb1/j0qDmhUhOoF+M=";
  };

  cargoHash = "sha256-VoIAwPrkhrRl48czXtKWmLTktsZ/U4TVV924wx0DL+A=";

  meta = {
    description = "A CLI tool to drive test-driven Rust workshops";
    homepage = "https://github.com/mainmatter/rust-workshop-runner";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ RaghavSood ];
    mainProgram = "wr";
  };
}
