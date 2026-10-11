{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "vitess";
  version = "24.0.4";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = "vitess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jwkK0AhYCAeFqo6EiDuEFeyL3NGS9am/Tii0VF47oVI=";
  };

  vendorHash = "sha256-ZkdEr6SWvkCeTPkxzyVdnSKhyNTAx1hYjcVZVn591Pg=";

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
