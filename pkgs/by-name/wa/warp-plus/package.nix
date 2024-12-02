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
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "bepass-org";
    repo = "warp-plus";
    rev = "v${version}";
    hash = "sha256-fFyYch14JqXSmnplPJ8c3epOxromZmEJAdcuSgkKbcM=";
  };

  vendorHash = "sha256-/rBZqrX9xZT8yOZwynkOOQyPl0govNmvsEqWVxsuvB4=";

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
