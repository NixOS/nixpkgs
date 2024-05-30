{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  testers,
  wakatime-cli,
}:

buildGo122Module rec {
  pname = "wakatime-cli";
  version = "1.90.0";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    hash = "sha256-A2YrDrXmMR4BJUOYuo3h3Pa5HqyYSoDr/qdH54INU3w=";
  };

  vendorHash = "sha256-pejrUFcv9c4ZAE3Cuw7uytc1T2pr7SOZNJ/Wr8K+fas=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wakatime/wakatime-cli/pkg/version.Version=${version}"
  ];

  checkFlags =
    let
      skippedTests = [
        # Tests requiring network
        "TestFileExperts"
        "TestSendHeartbeats"
        "TestSendHeartbeats_ExtraHeartbeats"
        "TestSendHeartbeats_IsUnsavedEntity"
        "TestSendHeartbeats_NonExistingExtraHeartbeatsEntity"
        "TestFileExperts_Err(Auth|Api|BadRequest)"

        # Flaky tests
        "TestLoadParams_ApiKey_FromVault_Err_Darwin"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests.version = testers.testVersion {
    package = wakatime-cli;
    command = "HOME=$(mktemp -d) wakatime-cli --version";
  };

  meta = with lib; {
    homepage = "https://wakatime.com/";
    description = "WakaTime command line interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sigmanificient ];
    mainProgram = "wakatime-cli";
  };
}
