{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "vacuum-go";
  version = "0.16.6";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    # using refs/tags because simple version gives: 'the given path has multiple possibilities' error
    tag = "v${finalAttrs.version}";
    hash = "sha256-20Ty0j0oRtMY6FLCCfu4o+qeDDMnjgEvUCUaWlqJ5dU=";
  };

  vendorHash = "sha256-ClocrabgCfizLVr+/O96qpiwAq7TxYB4uM9gtjeKbQA=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  subPackages = [ "./vacuum.go" ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "vacuum version";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "The world's fastest OpenAPI & Swagger linter";
    homepage = "https://quobix.com/vacuum";
    changelog = "https://github.com/daveshanley/vacuum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "vacuum";
    maintainers = with lib.maintainers; [ konradmalik ];
  };
})
