{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "topicctl";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-QY3+Il/U0Y1rlRS2ptKIprbaGOQV71r6HsSr35gB9FY=";
  };

  vendorHash = "sha256-M/lNhGD9zNmwkzTAjp0lbAeliNpLOCVJbOG16N76QL4=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = with lib; {
    description = "Tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [
      eskytthe
      srhb
    ];
    mainProgram = "topicctl";
  };
}
