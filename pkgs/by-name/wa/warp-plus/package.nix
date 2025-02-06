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
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "warp-plus";
    rev = "v${version}";
    hash = "sha256-gDn4zicSD+Hz3GsL6pzGpUaiHcw+8KHDaOJGCML6LOA=";
  };

  vendorHash = "sha256-MWzF9+yK+aUr8D4d64+qCD6XIqtmWH5hCLmQoksgFf8=";

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
  };
}
