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
  version = "1.2.6-unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "warp-plus";
    rev = "08d43e9e4c079534e47ba19fb2965c968c9621b2";
    hash = "sha256-MHz8b1whSzUJO0YogxMPuXMaQRfR+xxSYhFxq412EmE=";
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
