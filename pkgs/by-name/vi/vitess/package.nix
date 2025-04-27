{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule rec {
  pname = "vitess";
  version = "21.0.4";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QapbbLZ/wDCKYQW98l780PT4ZEXAbhW0o4Zk2MlG6DQ=";
  };

  vendorHash = "sha256-Bc9rhfGSjqhDQBOPS4noW8qJ4P5xLtVcokRhDbqP3a0=";

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
