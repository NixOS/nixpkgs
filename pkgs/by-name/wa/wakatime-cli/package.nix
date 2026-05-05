{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wakatime-cli,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "wakatime-cli";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nl9OoKDXcSNyI9UxdqsMSRF9Etz1p1jC6TmgY+0rKfg=";
  };

  vendorHash = "sha256-OfnXj6X2JIN/lLCvB8LLYeqNj1aW3GuA1hCiw+219QQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wakatime/wakatime-cli/pkg/version.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags =
    let
      skippedTests = [
        "TestLoadParams_APIKey_FromVault_Err_Darwin"
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
