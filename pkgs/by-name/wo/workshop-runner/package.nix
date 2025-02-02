{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "workshop-runner";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "rust-workshop-runner";
    rev = "v${version}";
    hash = "sha256-8Qq3kXFR4z9k7I6b9hN1JKOGNkzydo/wA99/X17iSkk=";
  };

  cargoHash = "sha256-pvcIN2nxLTt4nDEviJBdlX69xPtLZMyH2nVveOpD1R0=";

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
