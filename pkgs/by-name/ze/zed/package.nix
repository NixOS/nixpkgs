{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  zed,
}:

buildGoModule (finalAttrs: {
  pname = "zed";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "zed-archive";
    rev = "v${finalAttrs.version}";
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
    "-X=github.com/brimdata/zed/cli.version=${finalAttrs.version}"
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

  meta = {
    description = "Novel data lake based on super-structured data";
    homepage = "https://zed.brimdata.io";
    changelog = "https://github.com/brimdata/zed/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      dit7ya
      knl
    ];
  };
})
