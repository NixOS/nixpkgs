{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "xeol";
  version = "0.9.14";

  src = fetchFromGitHub {
    owner = "xeol-io";
    repo = "xeol";
    rev = "refs/tags/v${version}";
    hash = "sha256-ubgOZFCWBU5wtxL7l7yHplnVOBwf+b6MMWgP/W0VwW8=";
  };

  vendorHash = "sha256-X3RJiqndHsApKHfAaZVw3ZdmxMT/+aNht2Jx5uHX1EQ=";

  subPackages = [
    "cmd/xeol/"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X=main.version=${version}"
    "-X=main.gitCommit=${src.rev}"
    "-X=main.buildDate=1970-01-01T00:00:00Z"
    "-X=main.gitDescription=${src.rev}"
  ];

  meta = with lib; {
    description = "Scanner for end-of-life (EOL) software and dependencies in container images, filesystems, and SBOMs";
    homepage = "https://github.com/xeol-io/xeol";
    changelog = "https://github.com/xeol-io/xeol/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "xeol";
  };
}
