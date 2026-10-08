{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topcoat-cli";
  version = "0.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "topcoat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gslnny08zjnKN+2DDXoXWYqihwrgUvV9wRaZrAUF5l4=";
  };

  cargoHash = "sha256-g11IsGMUcIzF+CC5sjIbX1pRpjmZCLynblaPWNvlelM=";

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
