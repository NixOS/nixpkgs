{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "trajan";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "trajan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1YtwO4xT1KO1wZjeMEMpxbMsUXFgaprnAmhXqqFV9Xs=";
  };

  vendorHash = "sha256-xJdfYpVjpkyKlSPeQZ6SlNuq4ckyLw0kA66LXweS1dU=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.GitCommit=${finalAttrs.src.rev}"
    "-X=main.BuildDate=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "Multi-platform CI/CD vulnerability detection and attack automation tool";
    homepage = "https://github.com/praetorian-inc/trajan";
    changelog = "https://github.com/praetorian-inc/trajan/releases/tag/v${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "trajan";
  };
})
