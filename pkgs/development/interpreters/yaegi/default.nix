{ lib
, buildGoModule
, fetchFromGitHub
, testers
, yaegi
}:

buildGoModule rec {
  pname = "yaegi";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "yaegi";
    rev = "v${version}";
    hash = "sha256-ZV1HidHJvwum18QIIwQiCcRcitZdHk5+FxkPs6YgDac=";
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
    homepage = "https://github.com/traefik/yaegi";
    changelog = "https://github.com/traefik/yaegi/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
