{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "topicctl";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-i7Gu7bk7J8+kG6gWpB+8hyIQs7B3TNQmYvLyQQ0ZGtc=";
  };

  vendorHash = "sha256-aoFMYgyZnXmPg3fjwydGm85WKcT+Jez07a4JX1o3Mmo=";

  ldflags = [
    "-X main.BuildVersion=${finalAttrs.version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = {
    description = "Tool for easy, declarative management of Kafka topics";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eskytthe
      srhb
    ];
    mainProgram = "topicctl";
  };
})
