{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "symposium";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "symposium-dev";
    repo = "symposium";
    tag = "symposium-v${finalAttrs.version}";
    hash = "sha256-6x5feHW8CoQgf9npimlnY8vqb2MXWkYFlDmj3bR4oOI=";
  };

  cargoHash = "sha256-oUCglBkQuOUpxJuM67ZACl8Jv5gP42EBbLEOph+IeOA=";

  checkFlags = [
    # Requires network access
    "--skip=plugins::tests::check_crate_exists_on_crates_io"
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^symposium-v([0-9.]+)$" ];
  };

  meta = {
    description = "Provides cargo-agents that matches AI coding agent skills, hooks, and MCP servers to a Rust project's dependency graph";
    homepage = "https://symposium.dev";
    changelog = "https://github.com/symposium-dev/symposium/blob/symposium-v${finalAttrs.src.rev}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      johnrtitor
    ];
    mainProgram = "cargo-agents";
  };
})
