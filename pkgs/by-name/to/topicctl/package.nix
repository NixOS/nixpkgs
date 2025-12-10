{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "topicctl";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-49byQWrv0yDPCAMcgltlDnmYZ5TWyTUIZy0K46CiTUs=";
  };

  vendorHash = "sha256-ltvWWB0Y5arPV8o3bSYHcDf1ZSRRCrPriXklShj/fjo=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = {
    description = "Tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eskytthe
      srhb
    ];
    mainProgram = "topicctl";
  };
}
