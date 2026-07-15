{
  lib,
  fetchFromGitHub,
  rustPlatform,

  _binaryName ? "zjstatus", # passed to `cargo build --bin`
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zjstatus";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "dj95";
    repo = "zjstatus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sjMs63OaRhwCrl46v1A+K2EJdqnw63Pc7BMnHqiU790=";
  };

  cargoHash = "sha256-jg7EpcA3o/Qdb1eIspZQI3TX3+7gc3YX+FB4l4FZX44=";

  cargoBuildFlags = [ "--bin=${_binaryName}" ];

  meta = {
    description = "Configurable statusbar plugin for Zellij";
    homepage = "https://github.com/dj95/zjstatus";
    changelog = "https://github.com/dj95/zjstatus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
