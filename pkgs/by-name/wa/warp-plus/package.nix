{
  lib,
  buildGoModule,
  fetchFromGitHub,

  nix-update-script,
  testers,
  warp-plus,
}:

buildGoModule rec {
  pname = "warp-plus";
  version = "1.2.6-unstable-2025-09-13";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "warp-plus";
    rev = "4af9b2abfc4e79dceea41ac577f1683f62f57b8c";
    hash = "sha256-7i/06Qn+BRH/bWel9OvgVUAZZSwL2Euv179JDJNn2EE=";
  };

  vendorHash = "sha256-GmxiQk50iQoH2J/qUVvl9RBz6aIQp8RURqTzrl6NdCY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    tests.version = testers.testVersion {
      package = warp-plus;
      command = "warp-plus version";
    };
  };

  meta = {
    description = "Warp + Psiphon, an anti censorship utility for Iran";
    homepage = "https://github.com/bepass-org/warp-plus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "warp-plus";
  };
}
