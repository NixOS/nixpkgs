{
  lib,
  fetchFromGitHub,
  rustPlatform,

  _binaryName ? "zjstatus", # passed to `cargo build --bin`
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zjstatus";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "dj95";
    repo = "zjstatus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-duNUjFZDzQM+3BdPf+5GD4okYnYfW6vhBlRqgPLrMFc=";
  };

  cargoHash = "sha256-2h+EvXiQyoZ3Wb9HJpnL4aZnHG0I11FYsT4WPU+ZHsE=";

  cargoBuildFlags = [ "--bin=${_binaryName}" ];

  meta = {
    description = "Configurable statusbar plugin for Zellij";
    homepage = "https://github.com/dj95/zjstatus";
    changelog = "https://github.com/dj95/zjstatus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
