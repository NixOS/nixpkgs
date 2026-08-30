{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "vacuum-go";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P9d24F2ij32QG7j9bOch9EEGepDV77lLMpMO3pEzMIg=";
  };

  vendorHash = "sha256-IX80z+3IpgZPqdklJzTZyOlLDM6Qbw8y1Q344r5TYpc=";

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
