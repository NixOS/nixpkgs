{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gitMinimal,
  gitSetupHook,
  jujutsu,
}:
buildGoModule (finalAttrs: {
  pname = "yatto";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "handlebargh";
    repo = "yatto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sso0LlKzE/OJILCf7O5mdPgk6BUTiziQq2tcxcPMtkI=";
  };

  vendorHash = "sha256-8bCk6c/EyghsHKLinWGIJhbl76j3V/rzTmrCWh+5cIU=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [
    gitMinimal
    gitSetupHook
    jujutsu
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestJjCommit"
        "TestJjContributors"
        "TestJjUser"
        "TestResolver/AllContributors_function_resolves_correctly"
        "TestResolver"
        "TestE2E_AddEditDeleteProject"
        "TestE2E_AddEditDeleteProject/jj"
        "TestE2E_AddEditDeleteTask"
        "TestE2E_AddEditDeleteTask/jj"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Terminal-based to-do application built with Bubble Tea";
    homepage = "https://github.com/handlebargh/yatto";
    changelog = "https://github.com/handlebargh/yatto/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "yatto";
  };
})
