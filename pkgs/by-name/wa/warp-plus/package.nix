{
  lib,
  buildGo124Module,
  fetchFromGitHub,

  nix-update-script,
  versionCheckHook,
}:

# fails with go 1.25, downgrade to 1.24
# error tls.ConnectionState: struct field count mismatch: 17 vs 16
buildGo124Module (finalAttrs: {
  pname = "warp-plus";
  version = "1.2.6-unstable-2025-10-28";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "warp-plus";
    rev = "3653f7519d2a08a36222accff6899522bb8b03d0";
    hash = "sha256-T0YTxQ7iciv5i7lw+bU00B6iYquzBwzYkAlOGZiKeWc=";
  };

  vendorHash = "sha256-GmxiQk50iQoH2J/qUVvl9RBz6aIQp8RURqTzrl6NdCY=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  patches = [
    # https://github.com/bepass-org/warp-plus/pull/291
    ./fix-endpoints.patch
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestStdNetBindReceiveFuncAfterClose"
        "TestConcurrencySafety"
        "TestNoiseHandshake"
        "TestTwoDevicePing"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    changelog = "https://github.com/bepass-org/warp-plus/releases";
    description = "Warp + Psiphon, an anti censorship utility for Iran";
    homepage = "https://github.com/bepass-org/warp-plus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "warp-plus";
  };
})
