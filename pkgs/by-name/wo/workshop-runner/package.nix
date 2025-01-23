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

  useFetchCargoVendor = true;
  cargoHash = "sha256-pDXD59sP86pleL/sC4+jWRdd8WVpX1zEL6rbTH4MHfE=";

  meta = {
    description = "CLI tool to drive test-driven Rust workshops";
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
