with import ../../../default.nix {};
let
openssl_lib_marked = import ./openssl-lib-marked.nix;
self = rec {
  name = "ql-to-nix";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    gcc stdenv
    openssl fuse libuv libmysqlclient libfixposix libev sqlite
    freetds
    lispPackages.quicklisp-to-nix lispPackages.quicklisp-to-nix-system-info
  ];
  CPATH = "${libfixposix}/include";
  LD_LIBRARY_PATH = "${openssl.out}/lib:${fuse}/lib:${libuv}/lib:${libev}/lib:${libmysqlclient}/lib:${libmysqlclient}/lib/mysql:${postgresql.lib}/lib:${sqlite.out}/lib:${libfixposix}/lib:${freetds}/lib:${openssl_lib_marked}/lib";
};
in stdenv.mkDerivation self
