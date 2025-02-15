{ lib, stdenv, fetchurl, unzip, zlib, readline, ncurses
, updateAutotoolsGnuConfigScriptsHook

# for tests
, python3Packages, sqldiff, sqlite-analyzer, sqlite-rsync, tinysparql

# uses readline & ncurses for a better interactive experience if set to true
, interactive ? false

, gitUpdater
}:

let
  archiveVersion = import ./archive-version.nix lib;
in

stdenv.mkDerivation rec {
  pname = "sqlite${lib.optionalString interactive "-interactive"}";
  version = "3.48.0";

  # nixpkgs-update: no auto update
  # NB! Make sure to update ./tools.nix src (in the same directory).
  src = fetchurl {
    url = "https://sqlite.org/2025/sqlite-autoconf-${archiveVersion version}.tar.gz";
    hash = "sha256-rJkvf8o5id5+0f6ZwWNj+Eh5TIwyoVja/U65J6LgL9U=";
  };
  docsrc = fetchurl {
    url = "https://sqlite.org/2025/sqlite-doc-${archiveVersion version}.zip";
    hash = "sha256-PcE3/NfGrLMmr2CmG5hE3RXTdzywXnqc4nbEH3E9dlo=";
  };

  patches = [
    # https://sqlite.org/forum/forumpost/3380558ea82c8a3e
    # Can be removed with the next release.
    # Test: pkgsStatic.gnupg
    ./Libs.private.patch

    # https://sqlite.org/forum/forumpost/00f3aab3d3be9690
    # https://sqlite.org/src/info/d7c07581
    # TODO: Remove in 3.49.0
    ./3.48.0-fk-conflict-handling.patch
  ];

  outputs = [ "bin" "dev" "man" "doc" "out" ];
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook unzip ];
  buildInputs = [ zlib ] ++ lib.optionals interactive [ readline ncurses ];

  # required for aarch64 but applied for all arches for simplicity
  preConfigure = ''
    patchShebangs configure
  '';

  configureFlags = [ "--enable-threadsafe" ] ++ lib.optional interactive "--enable-readline";

  env.NIX_CFLAGS_COMPILE = toString ([
    "-DSQLITE_ENABLE_COLUMN_METADATA"
    "-DSQLITE_ENABLE_DBSTAT_VTAB"
    "-DSQLITE_ENABLE_JSON1"
    "-DSQLITE_ENABLE_FTS3"
    "-DSQLITE_ENABLE_FTS3_PARENTHESIS"
    "-DSQLITE_ENABLE_FTS3_TOKENIZER"
    "-DSQLITE_ENABLE_FTS4"
    "-DSQLITE_ENABLE_FTS5"
    "-DSQLITE_ENABLE_PREUPDATE_HOOK"
    "-DSQLITE_ENABLE_RTREE"
    "-DSQLITE_ENABLE_SESSION"
    "-DSQLITE_ENABLE_STMT_SCANSTATUS"
    "-DSQLITE_ENABLE_UNLOCK_NOTIFY"
    "-DSQLITE_SOUNDEX"
    "-DSQLITE_SECURE_DELETE"
    "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    "-DSQLITE_MAX_EXPR_DEPTH=10000"
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
    export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lm"

    echo ""
    echo "NIX_CFLAGS_COMPILE = $NIX_CFLAGS_COMPILE"
    echo ""
  '';

  postInstall = ''
    mkdir -p $doc/share/doc
    unzip $docsrc
    mv sqlite-doc-${archiveVersion version} $doc/share/doc/sqlite
  '';

  doCheck = false; # fails to link against tcl

  passthru = {
    tests = {
      inherit (python3Packages) sqlalchemy;
      inherit sqldiff sqlite-analyzer sqlite-rsync tinysparql;
    };

    updateScript = gitUpdater {
      # No nicer place to look for patest version.
      url = "https://github.com/sqlite/sqlite.git";
      # Expect tags like "version-3.43.0".
      rev-prefix = "version-";
    };
  };

  meta = with lib; {
    changelog = "https://www.sqlite.org/releaselog/${lib.replaceStrings [ "." ] [ "_" ] version}.html";
    description = "Self-contained, serverless, zero-configuration, transactional SQL database engine";
    downloadPage = "https://sqlite.org/download.html";
    homepage = "https://www.sqlite.org/";
    license = licenses.publicDomain;
    mainProgram = "sqlite3";
    maintainers = with maintainers; [ np ];
    platforms = platforms.unix ++ platforms.windows;
    pkgConfigModules = [ "sqlite3" ];
  };
}
