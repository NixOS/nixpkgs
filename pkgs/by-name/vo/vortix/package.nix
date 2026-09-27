{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vortix";
  version = "0.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Harry-kp";
    repo = "vortix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t4cxp8AcDTxb503Kwr6I0WVlxRktzStPjTFRwEk7ifo=";
  };

  cargoHash = "sha256-U5LZ6cGwazcu2V8WwaAAjF/W//WTe3GgnX4Js5AXzEU=";

  cargoBuildFlags = [
    "--package"
    "vortix"
  ];

  # The test suite reads and writes the invoking user's config directory.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal UI for WireGuard and OpenVPN with real-time telemetry and leak guarding";
    homepage = "https://github.com/Harry-kp/vortix";
    changelog = "https://github.com/Harry-kp/vortix/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "vortix";
    maintainers = with lib.maintainers; [ harry-kp ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
