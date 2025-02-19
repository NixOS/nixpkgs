{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "topicctl";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-3sYi2/c5twM10Q70/73Pd58qkAl5m8KqghG7oV+p2t8=";
  };

  vendorHash = "sha256-vPeqStOjoJPYKpdkHQNTBJFKc8NBjTH4A/W9B+HAy1I=";

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
