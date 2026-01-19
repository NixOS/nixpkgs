{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wash-cli";
  version = "1.0.0-beta.10";

  src = fetchFromGitHub {
    owner = "wasmCloud";
    repo = "wash";
    tag = "wash-v${finalAttrs.version}";
    hash = "sha256-g1OXyxLSKicMz0mnTyHNmihtt5WMx91bNo83NhZpx9s=";
  };

  cargoHash = "sha256-/Dah1F3pJBqtrCw7iVRGidQUl8rmD31Eoqva9ejc1iw=";

  checkFlags = [
    # Requires internet access
    "--skip=test_end_to_end_template_to_execution"
    "--skip=test_plugin_test_inspect_comprehensive"
    "--skip=test_pull_and_validate_ghcr_component"
  ];

  meta = {
    description = "Command-line tool for developing, building, and managing WebAssembly components";
    homepage = "https://github.com/wasmCloud/wash";
    changelog = "https://github.com/wasmCloud/wash/releases/tag/wash-v${finalAttrs.version}";
    mainProgram = "wash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bloveless ];
  };
})
