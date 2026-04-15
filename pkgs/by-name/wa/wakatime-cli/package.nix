{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wakatime-cli,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "wakatime-cli";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TOdAcT+IS6XONIfkASRvd7oTSSW5VX8w5q5ASvJlQb8=";
  };

  vendorHash = "sha256-HngszNLX2b2EVvh8ovouIEvjBOJL1jA5AhA6Y11ke9Y=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wakatime/wakatime-cli/pkg/version.Version=${finalAttrs.version}"
  ];

  # dial tcp 127.0.0.1:51272: connect: operation not permitted
  # and goroutine 33 [IO wait, 10 minutes] on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags =
    let
      skippedTests = [
        # Tests requiring network
        "TestFileExperts"
        "TestSendHeartbeats"
        "TestSendHeartbeats_ExtraHeartbeats"
        "TestSendHeartbeats_IsUnsavedEntity"
        "TestSendHeartbeats_NonExistingExtraHeartbeatsEntity"
        "TestSendHeartbeats_ExtraHeartbeatsIsUnsavedEntity"
        "TestFileExperts_Err(Auth|Api|BadRequest)"
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
})
