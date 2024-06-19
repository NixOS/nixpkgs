{ lib, buildGoModule, fetchFromGitHub, testers, vacuum-go }:

buildGoModule rec {
  pname = "vacuum-go";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    # using refs/tags because simple version gives: 'the given path has multiple possibilities' error
    rev = "refs/tags/v${version}";
    hash = "sha256-YQJKmLhxBnU6gKbhnzVAF53N1qS0/DQjjuOj8g6y+vo=";
  };

  vendorHash = "sha256-OhdN4/fNbXa5ZMakdf370rqyDlCVYjJ1IfeV6hEwcv4=";

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
