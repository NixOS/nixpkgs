{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topcoat-cli";
  version = "0.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "topcoat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xRzxqaQ73wd7uUPffaaiH9EdPm10i4AM3Ml7N0OrjQg=";
  };

  cargoHash = "sha256-btOlK33JgogZRy6cRwVJKYPBtAWtyNCf0pfqwtMRylQ=";

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
