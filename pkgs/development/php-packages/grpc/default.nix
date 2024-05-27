{
  buildPecl,
  pkg-config,
  lib,
  grpc,
}:

buildPecl {
  pname = "grpc";
  inherit (grpc) version src;

  sourceRoot = "${grpc.src.name}/src/php/ext/grpc";

  patches = [
    ./use-pkgconfig.patch # https://github.com/grpc/grpc/pull/35404
    ./skip-darwin-test.patch # https://github.com/grpc/grpc/pull/35403
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ grpc ];

  doCheck = true;

  meta = {
    description = "A high performance, open source, general RPC framework that puts mobile and HTTP/2 first.";
    homepage = "https://github.com/grpc/grpc/tree/master/src/php/ext/grpc";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
  };
}
