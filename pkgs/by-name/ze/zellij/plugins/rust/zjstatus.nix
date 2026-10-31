{
  lib,
  fetchFromGitHub,
  rustPlatform,

  _binaryName ? "zjstatus", # passed to `cargo build --bin`
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zjstatus";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "dj95";
    repo = "zjstatus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tn4PWTssBWTi76OaBl8bCjmMuAZAuS13zjHDJdAm3cA=";
  };

  cargoHash = "sha256-oQ0GzTHpmrG/+Uyw11Uztbz+k3PwnWwECaNa+YSwQaw=";

  cargoBuildFlags = [ "--bin=${_binaryName}" ];

  meta = {
    description = "Configurable statusbar plugin for Zellij";
    homepage = "https://github.com/dj95/zjstatus";
    changelog = "https://github.com/dj95/zjstatus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
