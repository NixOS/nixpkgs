{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wakatime-cli,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "wakatime-cli";
  version = "1.115.3";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    tag = "v${version}";
    hash = "sha256-czoAX9CKvIZjODeKcadX9vzBhOcMeyjwbljv1PrMtOg=";
  };

  vendorHash = "sha256-1yqpz3DqWHXw3ihh7YAKtl5Co91VAbBMRu68S/igrMc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wakatime/wakatime-cli/pkg/version.Version=${version}"
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
}
