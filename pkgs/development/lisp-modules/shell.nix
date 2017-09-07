with import ../../../default.nix {};
let
self = rec {
  name = "ql-to-nix";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    gcc stdenv
    openssl fuse libuv mariadb libfixposix libev sqlite
    freetds
    lispPackages.quicklisp-to-nix lispPackages.quicklisp-to-nix-system-info
  ];
  CPATH = "${libfixposix}/include";
  LD_LIBRARY_PATH = "${openssl.out}/lib:${fuse}/lib:${libuv}/lib:${libev}/lib:${mariadb}/lib:${postgresql.lib}/lib:${sqlite.out}/lib:${libfixposix}/lib:${freetds}/lib";
};
in stdenv.mkDerivation self
