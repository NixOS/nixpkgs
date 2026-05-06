{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "vitess";
  version = "24.0.0";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = "vitess";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MIds2Eez6MCO7BeTu2z+McydY1rYzY36ME6HDi4Pjiw=";
  };

  vendorHash = "sha256-9eATOQLdOtG0ablmNL8kNX8MD4wmV/WeDytrLbubMzw=";

  buildInputs = [ sqlite ];

  subPackages = [ "go/cmd/..." ];

  # integration tests require access to syslog and root
  doCheck = false;

  meta = {
    homepage = "https://vitess.io/";
    changelog = "https://github.com/vitessio/vitess/releases/tag/v${finalAttrs.version}";
    description = "Database clustering system for horizontal scaling of MySQL";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
