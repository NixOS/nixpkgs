{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xeol";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "xeol-io";
    repo = "xeol";
    tag = "v${version}";
    hash = "sha256-I7+gR4y0wVpQeDoRH2OYr38PGuyZ/lk5M3bX0VeAqfQ=";
  };

  vendorHash = "sha256-hPWjXTxk/jRkzvLYNgVlgj0hjzfikwel1bxSqWquVhk=";

  proxyVendor = true;

  subPackages = [ "cmd/xeol/" ];

  ldflags = [
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
