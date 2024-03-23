{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "xeol";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "xeol-io";
    repo = "xeol";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZBj/0/270Eo5iE6ZMcLH+CygoYW6/gXfGBldfdlGZOg=";
  };

  vendorHash = "sha256-fGOta+IsX/McUkQGOvf9ZlnCD1falDJSeU+AX359Zpw=";

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
