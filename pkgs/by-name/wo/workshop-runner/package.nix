{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "workshop-runner";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "rust-workshop-runner";
    rev = "v${version}";
    hash = "sha256-PfQPRbOPK1Y/j8Xtg78oDzBFUx8eiM3ZwRul/ao0SgI=";
  };

  cargoHash = "sha256-opV2IrqMIwdgrXY6V0jxFtrdP8NVmdlUdsLdfFNimt0=";

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
