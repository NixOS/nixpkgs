{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.6.1";
  vendorHash = "sha256-TOzIb8QmvoKlVwoVeYKLcyWgb/sQT4oYuIodtSZoufs=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dbRu+VjUxYZB1aWUZ2w/5+zKs5RcxWDqmYD9vmIGqG0=";
  };

  subPackages = [
    "cmd/trillian_log_server"
    "cmd/trillian_log_signer"
    "cmd/createtree"
    "cmd/deletetree"
    "cmd/updatetree"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/trillian";
    description = "Transparent, highly scalable and cryptographically verifiable data store";
    license = [ licenses.asl20 ];
    maintainers = [ ];
  };
}
