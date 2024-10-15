{ lib, buildGoModule, fetchFromGitHub, testers, vacuum-go }:

buildGoModule rec {
  pname = "vacuum-go";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    # using refs/tags because simple version gives: 'the given path has multiple possibilities' error
    rev = "refs/tags/v${version}";
    hash = "sha256-uNmjb1fj9bMawvNgITxu/RIZeLEn8JzIpFbSMrsmFIQ=";
  };

  vendorHash = "sha256-Yxzj3IAYp6C7qLbV2RV4lWZRDSheauZXvd+p5B5Y3qA=";

  CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  subPackages = [ "./vacuum.go" ];

  passthru = {
    tests.version = testers.testVersion {
      package = vacuum-go;
      command = "vacuum version";
      version = "v${version}";
    };
  };

  meta = {
    description = "The world's fastest OpenAPI & Swagger linter";
    homepage = "https://quobix.com/vacuum";
    changelog = "https://github.com/daveshanley/vacuum/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "vacuum";
    maintainers = with lib.maintainers; [ konradmalik ];
  };
}
