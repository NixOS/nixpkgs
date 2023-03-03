{ buildPecl, zlib, lib }:

buildPecl {
  pname = "grpc";

  version = "1.50.0";
  sha256 = "sha256-Lgvrw1HZywfvHTaF88T5dtKXu/lGR5xeS+TsqqNQCSc=";

  doCheck = true;
  checkTarget = "test";

  nativeBuildInputs = [ zlib ];

  meta = with lib; {
    description = "A high performance, open source, general RPC framework that puts mobile and HTTP/2 first.";
    license = licenses.asl20;
    homepage = "https://github.com/grpc/grpc/tree/master/src/php/ext/grpc";
    maintainers = teams.php.members;
  };
}
