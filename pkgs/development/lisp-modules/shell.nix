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
  CPATH = lib.makeSearchPath "include"
    [ libfixposix
    ];
  LD_LIBRARY_PATH = lib.makeLibraryPath
    [ cairo
      freetds
      fuse
      gdk-pixbuf
      glib
      gobject-introspection
      gtk3
      libev
      libfixposix
      libmysqlclient
      libuv
      openblas
      openssl
      openssl_lib_marked
      pango
      postgresql
      sqlite
      webkitgtk
    ]
    + ":${libmysqlclient}/lib/mysql";
};
in stdenv.mkDerivation self
