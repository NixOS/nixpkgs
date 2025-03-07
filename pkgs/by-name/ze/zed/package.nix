{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  zed,
}:

buildGoModule rec {
  pname = "zed";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NCoeTeOkxkCsj/nRBhMJeEshFuwozOXNJvgp8vyCQDk=";
  };

  vendorHash = "sha256-E9CXS3BQAglJV36BPgwhkb9SswxAj/yBcGqJ+XXwTmE=";

  subPackages = [
    "cmd/zed"
    "cmd/zq"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/brimdata/zed/cli.version=${version}"
  ];

  passthru.tests = {
    zed-version = testers.testVersion {
      package = zed;
    };
    zq-version = testers.testVersion {
      package = zed;
      command = "zq --version";
    };
  };

  meta = with lib; {
    description = "Novel data lake based on super-structured data";
    homepage = "https://zed.brimdata.io";
    changelog = "https://github.com/brimdata/zed/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      dit7ya
      knl
    ];
  };
}
