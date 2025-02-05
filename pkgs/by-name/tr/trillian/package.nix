{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.7.1";
  vendorHash = "sha256-muPKjhUbpBJBMq8abcgTzq8/bjGXVPLoYHqQJKv8a1k=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TOJqBfYVubwgDF/9i6lwmCLj6x0utzz0O7QJ5SqshCA=";
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
