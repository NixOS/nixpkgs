{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "workshop-runner";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "mainmatter";
    repo = "rust-workshop-runner";
    rev = "v${version}";
    hash = "sha256-vaCMnytN3GidEzn3r0zDyD2uBTLaLSnaho/j1Ti3yHE=";
  };

  cargoHash = "sha256-/Oj4B2W+fprOML1KdiU8fHkeGj1JXq8o0GlKxa46/64=";

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
