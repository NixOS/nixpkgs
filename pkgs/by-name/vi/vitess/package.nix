{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule rec {
  pname = "vitess";
  version = "22.0.0";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = "vitess";
    rev = "v${version}";
    hash = "sha256-YfFGKOYlsCy9mSjtRB+ajmXnXIB8Awjm54DGGhTnu5U=";
  };

  vendorHash = "sha256-0rgosDZn/DZcEK8f1JE2ICiOQX1GU2H93EEAlvesNE8=";

  buildInputs = [ sqlite ];

  subPackages = [ "go/cmd/..." ];

  # integration tests require access to syslog and root
  doCheck = false;

  meta = with lib; {
    homepage = "https://vitess.io/";
    changelog = "https://github.com/vitessio/vitess/releases/tag/v${version}";
    description = "Database clustering system for horizontal scaling of MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
