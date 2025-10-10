{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "tmuxai";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "alvinunreal";
    repo = "tmuxai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PbIPMKkUYgrIMoBB7AGB89e7MssnL4dxLDW4ATvY05M=";
  };

  vendorHash = "sha256-6X79tFZCiuVq3ZgHC/EhwF9Nlge/8UoubRG1O9DGwxc=";

  ldflags = [
    "-s"
    "-X=github.com/alvinunreal/tmuxai/internal.Version=v${finalAttrs.version}"
    "-X=github.com/alvinunreal/tmuxai/internal.Commit=${finalAttrs.src.rev}"
    "-X=github.com/alvinunreal/tmuxai/internal.Date=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-Powered, Non-Intrusive Terminal Assistant";
    homepage = "https://github.com/alvinunreal/tmuxai";
    changelog = "https://github.com/alvinunreal/tmuxai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "tmuxai";
  };
})
