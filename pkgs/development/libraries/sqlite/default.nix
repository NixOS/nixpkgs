{ stdenv, fetchzip, tcl, zlib, interactive ? false, readline ? null, ncurses ? null }:

assert interactive -> readline != null && ncurses != null;

with stdenv.lib;

let
  archiveVersion = version:
    let
      segments = splitString "." version;
      major = head segments;
      minor = concatMapStrings (fixedWidthNumber 2) (tail segments);
    in
    major + minor + "00";
in

stdenv.mkDerivation rec {
  name = "sqlite-${version}";
  version = "3.23.1";

  src = fetchzip {
    url = "https://sqlite.org/2018/sqlite-src-${archiveVersion version}.zip";
    sha256 = "1dshxmiqdiympg1i2jsz3x543zmcgzhn78lpsjc0546rir0s0zk0";
  };

  outputs = [ "bin" "dev" "out" ];
  separateDebugInfo = stdenv.isLinux;

  nativeBuildInputs = [ tcl ];
  buildInputs = [ zlib ]
    ++ optionals interactive [ readline ncurses ];

  configureFlags = [
    # Disables libtclsqlite.so, tcl is still required for the build itself:
    "--disable-tcl"
    "--enable-threadsafe"
  ] ++ optional interactive "--enable-readline";

  NIX_CFLAGS_COMPILE = [
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
  ];

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

    echo
    echo "NIX_CFLAGS_COMPILE = $NIX_CFLAGS_COMPILE"
    echo
  '';

  meta = {
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    downloadPage = http://sqlite.org/download.html;
    homepage = http://www.sqlite.org/;
    maintainers = with maintainers; [ eelco np ];
    platforms = platforms.unix;
  };
}
