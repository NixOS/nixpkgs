{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "vitess";
  version = "23.0.2";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = "vitess";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Da4BA1nPSYq9UvsF+nFOyGDMOrUYqSGe61eS6fqFnUk=";
  };

  vendorHash = "sha256-YhWa5eUeMCqmA+8Mi3lxQTSQ29xMpWWAb2BQPN1/+N8=";

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
