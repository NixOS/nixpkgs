{ buildPecl
, zlib
, lib
}:

buildPecl {
  pname = "grpc";
  version = "1.56.0";

  sha256 = "sha256-uzxYMUzExMBDtwv3FipOuuUHg0v1wqAUtn69jXAQnf4=";

  doCheck = true;
  checkTarget = "test";

  nativeBuildInputs = [ zlib ];

  meta = {
    description = "A high performance, open source, general RPC framework that puts mobile and HTTP/2 first.";
    homepage = "https://github.com/grpc/grpc/tree/master/src/php/ext/grpc";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
  };
}
