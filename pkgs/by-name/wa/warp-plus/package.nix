{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "warp-plus";
  version = "1.2.6-unstable-2025-11-17";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "warp-plus";
    rev = "f70ea7e4f193717c73f9a4357cbc98d6944b36bb";
    hash = "sha256-5H0iF+dc+3qQrFCPiaBxHMSoHsmciKvwX1SJX7TMjeE=";
  };

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  # Replaced `psiphon-tls` with release-branch.go1.26
  postPatch = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOSUMDB=off
    go mod edit -replace github.com/Psiphon-Labs/psiphon-tls=github.com/Psiphon-Labs/psiphon-tls@v0.0.0-20260429174135-190516348878
    if [ -n "$goModules" ]; then
      export GOPROXY="file://$goModules"
    fi
    #only built on windows
    rm wireguard/ipc/namedpipe/namedpipe_test.go
    go mod tidy
  '';

  proxyVendor = true;
  vendorHash = "sha256-mPIffXUHS4lnnJPlOfuQaGA/1oiQpdKVV3wkrlIH3nE=";

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
