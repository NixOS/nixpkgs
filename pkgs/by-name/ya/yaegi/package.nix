{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  yaegi,
}:

buildGoModule rec {
  pname = "yaegi";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "yaegi";
    rev = "v${version}";
    hash = "sha256-jpLx2z65KeCPC4AQgFmUUphmmiT4EeHwrYn3/rD4Rzg=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/yaegi"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = yaegi;
      command = "yaegi version";
    };
  };

  meta = with lib; {
    description = "Go interpreter";
    mainProgram = "yaegi";
    homepage = "https://github.com/traefik/yaegi";
    changelog = "https://github.com/traefik/yaegi/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ ];
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
}
