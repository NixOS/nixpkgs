{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "vitess";
  version = "24.0.3";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = "vitess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uORRLos9ybCYmqdR0XM4TwtLr1pmVnbDLCvHkjtl4rE=";
  };

  vendorHash = "sha256-S6hzgSIYJdTKFMFpNqYyWzcMGT4aSaWE6SfmOWB7NOM=";

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
