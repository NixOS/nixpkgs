{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "vacuum-go";
  version = "0.23.8";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YrYp9CL/ouFMC2agA6PT/OWKEDTRYR1uiR2JpQnS3wk=";
  };

  vendorHash = "sha256-86ie9wLBXnc4s5GAUiE0CiDkLl717GEN5PggXosMdRs=";

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
    description = "World's fastest OpenAPI & Swagger linter";
    homepage = "https://quobix.com/vacuum";
    changelog = "https://github.com/daveshanley/vacuum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "vacuum";
    maintainers = with lib.maintainers; [ konradmalik ];
  };
})
