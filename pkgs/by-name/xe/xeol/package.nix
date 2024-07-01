{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xeol";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "xeol-io";
    repo = "xeol";
    rev = "refs/tags/v${version}";
    hash = "sha256-/DWBDc8m5XYM5UBX5/GWuPRR3YktRar/LbENx2d5bc4=";
  };

  vendorHash = "sha256-9zDzwiVEVsfgVzSrouNtLYpjumoWGlfSDpGWbj+zCGQ=";

  subPackages = [ "cmd/xeol/" ];

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
    platforms = platforms.linux;
  };
}
