{
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminus-rs";
  version = "3.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gbiagomba";
    repo = "Terminus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i0hIZUV4EryduZvs56fu1pQDs8QIy5s1zBOF1m/gmwk=";
  };

  cargoHash = "sha256-bru1S9hzdrQ2XqFvBIbDMEQ6778ZmWlOrfLIdvyJWYw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    # reqwest's http3 feature is unstable and requires an explicit opt-in
    RUSTFLAGS = "--cfg reqwest_unstable";
  };

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for auditing web accessibility";
    homepage = "https://github.com/gbiagomba/Terminus";
    changelog = "https://github.com/gbiagomba/Terminus/blob/${finalAttrs.src.rev}/CHANGELOG.MD";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "terminus";
  };
})
