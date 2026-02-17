{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule (finalAttrs: {
  pname = "vitess";
  version = "23.0.0";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = "vitess";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gP++iix4jonsSgrAblhnT7XFCggCEMG7ve3GKTJuOoo=";
  };

  vendorHash = "sha256-jwlIOfBuIi1D40p21jF3LJw508zrovw0ukXUn27Sb9U=";

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
