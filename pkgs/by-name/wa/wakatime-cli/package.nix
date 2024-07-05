{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  testers,
  wakatime-cli,
}:

buildGo122Module rec {
  pname = "wakatime-cli";
  version = "1.93.0";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    hash = "sha256-S4AvAGpaxp5lKi9RnLLaN8qLURYsLWIzhtXKRgQPuGc=";
  };

  vendorHash = "sha256-+9zdEIaKQlLcBwFaY5Fe5mpHWQDqfV+j1TPmDkdRjyk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wakatime/wakatime-cli/pkg/version.Version=${version}"
  ];

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.22.4" "go 1.22.3"
  '';

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
