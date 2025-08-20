{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wakatime-cli,
}:

buildGoModule rec {
  pname = "wakatime-cli";
  version = "1.102.3";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    hash = "sha256-RnEyrbdYP8BYQ9M+iwikTfYF8HRosR6vhHiQJvGNZ/s=";
  };

  vendorHash = "sha256-s9nCr55XR/0ZriweDOBRIDpmp+GUE85FWLJkWXqX5/U=";

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

  meta = {
    homepage = "https://wakatime.com/";
    description = "WakaTime command line interface";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "wakatime-cli";
  };
}
