{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  yamlfmt,
}:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "yamlfmt";
    tag = "v${version}";
    hash = "sha256-eAcHl4h7c3HU901cuqzAPs49qRldxKQDxrWBmccmwos=";
  };

  vendorHash = "sha256-za95/Zj8MXJqt9tW6csaRlXFs+5ET/D4CUsCnGqcLQQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  passthru.tests.version = testers.testVersion {
    package = yamlfmt;
  };

  meta = with lib; {
    description = "Extensible command line tool or library to format yaml files";
    homepage = "https://github.com/google/yamlfmt";
    changelog = "https://github.com/google/yamlfmt/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
    mainProgram = "yamlfmt";
  };
}
