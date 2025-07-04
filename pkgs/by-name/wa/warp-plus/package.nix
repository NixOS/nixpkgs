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
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "warp-plus";
    rev = "v${version}";
    hash = "sha256-Zi428QI0DBIPEywXPi0TwDQWJuQyQcB6N5nqtYkkpHk=";
  };

  vendorHash = "sha256-cCMbda2dVZypGqy9zoh0D3lVHWw/HNbCaSe0Nj5wL6s=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestConcurrencySafety"
        "TestNoiseHandshake"
        "TestTwoDevicePing"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = warp-plus; };
  };

  meta = {
    description = "Warp + Psiphon, an anti censorship utility for Iran";
    homepage = "https://github.com/bepass-org/warp-plus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paveloom ];
    mainProgram = "warp-plus";
    # Doesn't work with Go toolchain >1.22, runtime error:
    # 'panic: tls.ConnectionState doesn't match'
    broken = true;
  };
}
