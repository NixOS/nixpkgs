{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topcoat-cli";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "topcoat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BsirKja5/ZIW4L6bDqIP6NfF8kmdaLrOAyJ705epevI=";
  };

  cargoHash = "sha256-/7P8JclH3jl1kOGOh2PMUJH8C9JOkYM64THBhLNrsCY=";

  cargoBuildFlags = [
    "-p"
    "topcoat-cli"
  ];
  cargoTestFlags = [
    "-p"
    "topcoat-cli"
  ];

  meta = {
    description = "CLI for Topcoat, a modular, batteries-included Rust web framework for server-rendered apps";
    homepage = "https://github.com/tokio-rs/topcoat";
    changelog = "https://github.com/tokio-rs/topcoat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "topcoat";
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})
