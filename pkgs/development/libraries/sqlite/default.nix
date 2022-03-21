{ lib, stdenv, fetchurl, zlib, interactive ? false, readline, ncurses
, python3Packages
, enableDeserialize ? false
}:

with lib;

let
  archiveVersion = import ./archive-version.nix lib;
in

stdenv.mkDerivation rec {
  pname = "sqlite${optionalString interactive "-interactive"}";
  version = "3.37.2";

  # nixpkgs-update: no auto update
  # NB! Make sure to update ./tools.nix src (in the same directory).
  src = fetchurl {
    url = "https://sqlite.org/2022/sqlite-autoconf-${archiveVersion version}.tar.gz";
    sha256 = "sha256-QImo2bRnU3s/JG8he4TNduALHRqXH+WsoeMOIw5Gstg=";
  };

  outputs = [ "bin" "dev" "out" ];
  separateDebugInfo = stdenv.isLinux;

  buildInputs = [ zlib ] ++ optionals interactive [ readline ncurses ];

  # required for aarch64 but applied for all arches for simplicity
  preConfigure = ''
    patchShebangs configure
  '';

  configureFlags = [ "--enable-threadsafe" ] ++ optional interactive "--enable-readline";

  NIX_CFLAGS_COMPILE = toString ([
    "-DSQLITE_ENABLE_COLUMN_METADATA"
    "-DSQLITE_ENABLE_DBSTAT_VTAB"
    "-DSQLITE_ENABLE_JSON1"
    "-DSQLITE_ENABLE_FTS3"
    "-DSQLITE_ENABLE_FTS3_PARENTHESIS"
    "-DSQLITE_ENABLE_FTS3_TOKENIZER"
    "-DSQLITE_ENABLE_FTS4"
    "-DSQLITE_ENABLE_FTS5"
    "-DSQLITE_ENABLE_RTREE"
    "-DSQLITE_ENABLE_STMT_SCANSTATUS"
    "-DSQLITE_ENABLE_UNLOCK_NOTIFY"
    "-DSQLITE_SOUNDEX"
    "-DSQLITE_SECURE_DELETE"
    "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    "-DSQLITE_MAX_EXPR_DEPTH=10000"
  ] ++ lib.optionals enableDeserialize [
    # Can be removed in v3.36+, as this will become the default
    "-DSQLITE_ENABLE_DESERIALIZE"
  ]);

  # Test for features which may not be available at compile time
  preBuild = ''
    # Use pread(), pread64(), pwrite(), pwrite64() functions for better performance if they are available.
    if cc -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread_pwrite_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread(0, NULL, 0, 0);\n  pwrite(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD"
    fi
    if cc -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread64_pwrite64_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD64"
    elif cc -D_LARGEFILE64_SOURCE -Werror=implicit-function-declaration -x c - -o "$TMPDIR/pread64_pwrite64_test" <<< \
      ''$'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}'; then
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DUSE_PREAD64 -D_LARGEFILE64_SOURCE"
    fi

    # Necessary for FTS5 on Linux
    export NIX_LDFLAGS="$NIX_LDFLAGS -lm"

    echo ""
    echo "NIX_CFLAGS_COMPILE = $NIX_CFLAGS_COMPILE"
    echo ""
  '';

  postInstall = ''
    # Do not contaminate dependent libtool-based projects with sqlite dependencies.
    sed -i $out/lib/libsqlite3.la -e "s/dependency_libs=.*/dependency_libs='''/"
  '';

  doCheck = false; # fails to link against tcl

  passthru.tests = {
    inherit (python3Packages) sqlalchemy;
  };

  meta = {
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    downloadPage = "https://sqlite.org/download.html";
    homepage = "https://www.sqlite.org/";
    license = licenses.publicDomain;
    mainProgram = "sqlite3";
    maintainers = with maintainers; [ eelco np ];
    platforms = platforms.unix ++ platforms.windows;
  };
}
