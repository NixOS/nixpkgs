{ lib
, buildGoModule
, fetchFromGitHub
, testers
, yaegi
}:

buildGoModule rec {
  pname = "yaegi";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "yaegi";
    rev = "v${version}";
    hash = "sha256-AplNd9+Z+bVC4/2aFKwhabMvumF9IPcSX8X8H0z/ADA=";
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
    description = "A Go interpreter";
    mainProgram = "yaegi";
    homepage = "https://github.com/traefik/yaegi";
    changelog = "https://github.com/traefik/yaegi/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
