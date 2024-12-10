{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vacuum-go,
}:

buildGoModule rec {
  pname = "vacuum-go";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    # using refs/tags because simple version gives: 'the given path has multiple possibilities' error
    rev = "refs/tags/v${version}";
    hash = "sha256-t/KbwyxInMvxsICdh0kix27+MKre480+I/KkbwxLg1M=";
  };

  vendorHash = "sha256-6ay7aGFf50txrRZbjOuG2rVeetVo0SWgpURLmFyhszA=";

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
