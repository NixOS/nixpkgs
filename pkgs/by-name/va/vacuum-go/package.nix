{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vacuum-go,
}:

buildGoModule rec {
  pname = "vacuum-go";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    # using refs/tags because simple version gives: 'the given path has multiple possibilities' error
    tag = "v${version}";
    hash = "sha256-wlxEKAP8A8T+rBQ2HqoOdBlkqFBqrIxuuEidPAeUO3E=";
  };

  vendorHash = "sha256-1lr1VQU4JHg0PZbjAUmALFZJiYc+HTwrk0E/t/1qXqE=";

  env.CGO_ENABLED = 0;
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
