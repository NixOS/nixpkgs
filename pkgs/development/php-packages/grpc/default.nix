<<<<<<< HEAD
{ buildPecl
, zlib
, lib
}:

buildPecl {
  pname = "grpc";
  version = "1.56.0";

  sha256 = "sha256-uzxYMUzExMBDtwv3FipOuuUHg0v1wqAUtn69jXAQnf4=";
=======
{ buildPecl, zlib, lib }:

buildPecl {
  pname = "grpc";

  version = "1.50.0";
  sha256 = "sha256-Lgvrw1HZywfvHTaF88T5dtKXu/lGR5xeS+TsqqNQCSc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;
  checkTarget = "test";

  nativeBuildInputs = [ zlib ];

<<<<<<< HEAD
  meta = {
    description = "A high performance, open source, general RPC framework that puts mobile and HTTP/2 first.";
    homepage = "https://github.com/grpc/grpc/tree/master/src/php/ext/grpc";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
=======
  meta = with lib; {
    description = "A high performance, open source, general RPC framework that puts mobile and HTTP/2 first.";
    license = licenses.asl20;
    homepage = "https://github.com/grpc/grpc/tree/master/src/php/ext/grpc";
    maintainers = teams.php.members;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
