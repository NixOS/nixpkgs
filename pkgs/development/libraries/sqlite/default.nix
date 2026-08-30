{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  unzip,
  tcl,
  zlib,
  readline,
  ncurses,

  # for tests
  python3Packages,
  sqldiff,
  sqlite-analyzer,
  sqlite-rsync,
  tinysparql,

  # uses readline & ncurses for a better interactive experience if set to true
  interactive ? false,

  gitUpdater,
  buildPackages,
}:

let
  archiveVersion = import ./archive-version.nix lib;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite${lib.optionalString interactive "-interactive"}";
  version = "3.53.3";

  # nixpkgs-update: no auto update
  # NB! Make sure to update ./tools.nix src (in the same directory).
  src = fetchurl {
    url = "https://sqlite.org/2026/sqlite-src-${archiveVersion finalAttrs.version}.zip";
    hash = "sha256-u4C/ijv/wZJBzoq6WkvHTpw5gAE8sLXw8JdqmVFpQq8=";
  };
  docsrc = fetchurl {
    url = "https://sqlite.org/2026/sqlite-doc-${archiveVersion finalAttrs.version}.zip";
    hash = "sha256-Fo+Zhph2vPTbjZPvoqSDqcgVNlN9AZAMWM110KZ8yic=";
  };

  outputs = [
    "bin"
    "dev"
    "man"
    "doc"
    "out"
  ];
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    unzip
    tcl
  ];

  patches = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # Add a missing `-DBUILD_sqlite` to one place in the makefile
    #
    # TODO(@Ericson2314): drop once a release contains it, and (before that)
    # make unconditional (it is not cross-specific) next mass rebuild.
    (fetchpatch {
      url = "https://github.com/sqlite/sqlite/commit/67c202ab67398f6a27eaa6316e31254c065928cd.patch";
      includes = [ "main.mk" ];
      hash = "sha256-JJnIF/2SmGgPzQe7E4DmC61komZpbmjnIemggpBPLdM=";
    })

    # --with-tcl and --with-tclsh were tangled together in bad ways. I
    # (@Ericson2314) wrote this patch to untangle and submit upstream. It
    # unbreaks our cross builds.
    #
    # https://sqlite.org/forum/forumpost?udc=1&name=fe9e99eb27c8c2ba
    #
    # The intent is to submit it there once I have enough forum privileges
    # to do so. The Nixpkgs copy will remain the sole copy in the meantime.
    #
    # TODO make it unconditional next mass rebuild. If version of this is
    # upstreamed, also replace this with a fetchpatch of the final landed
    # change for older versions.
    ./separate-build-and-host-tcl.patch
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals interactive [
    readline
    ncurses
  ];

  strictDeps = true;

  # required for aarch64 but applied for all arches for simplicity
  preConfigure = ''
    patchShebangs configure
  '';

  # sqlite relies on autosetup now; so many of the
  # previously-understood flags are gone. They should instead be set
  # on a per-output basis.
  setOutputFlags = false;

  # Follow other Tcl modules.
  env.TCLLIBDIR = "${placeholder "out"}/lib/sqlite${version}";

  configureFlags = [
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--libdir=${placeholder "out"}/lib"
    (if stdenv.hostPlatform.isStatic then "--disable-tcl" else "--with-tcl=${lib.getLib tcl}/lib")
    # Enabling limit-on-update/delete by adding -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT to NIX_CFLAGS_COMPILE does not work: the lemon parser generator (built early in buildPhase) doesn't receive the flag when it's invoked, as it's not been wrapped with Nix magic.
    "--enable-update-limit"
  ]
  # With the patch above this names only what runs the code generators, not
  # the library, so it is the build platform's and is orthogonal to both
  # `--with-tcl` and `--disable-tcl`.
  #
  # TODO pass this unconditionally next mass rebuild: which interpreter runs
  # the generators is not something to leave to a search of `PATH`.
  ++ lib.optional (
    stdenv.buildPlatform != stdenv.hostPlatform
  ) "--with-tclsh=${lib.getExe' buildPackages.tcl "tclsh"}"
  ++ lib.optional (!interactive) "--disable-readline"
  # autosetup only looks up readline.h in predefined set of directories.
  ++ lib.optional interactive "--with-readline-header=${lib.getDev readline}/include/readline/readline.h"
  ++ lib.optional (stdenv.hostPlatform.isStatic) "--disable-shared";

  env.NIX_CFLAGS_COMPILE = toString [
    "-DSQLITE_ENABLE_COLUMN_METADATA"
    "-DSQLITE_ENABLE_DBSTAT_VTAB"
    "-DSQLITE_ENABLE_JSON1"
    "-DSQLITE_ENABLE_FTS3"
    "-DSQLITE_ENABLE_FTS3_PARENTHESIS"
    "-DSQLITE_ENABLE_FTS3_TOKENIZER"
    "-DSQLITE_ENABLE_FTS4"
    "-DSQLITE_ENABLE_FTS5"
    "-DSQLITE_ENABLE_GEOPOLY"
    "-DSQLITE_ENABLE_MATH_FUNCTIONS"
    "-DSQLITE_ENABLE_PERCENTILE"
    "-DSQLITE_ENABLE_PREUPDATE_HOOK"
    "-DSQLITE_ENABLE_RBU"
    "-DSQLITE_ENABLE_RTREE"
    "-DSQLITE_ENABLE_SESSION"
    "-DSQLITE_ENABLE_STMT_SCANSTATUS"
    "-DSQLITE_ENABLE_UNLOCK_NOTIFY"
    "-DSQLITE_SOUNDEX"
    "-DSQLITE_SECURE_DELETE"
    "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    "-DSQLITE_MAX_EXPR_DEPTH=10000"
  ];

  # Test for features which may not be available at compile time
  preBuild = ''
    # Necessary for FTS5 on Linux
    export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lm"

    echo ""
    echo "NIX_CFLAGS_COMPILE = $NIX_CFLAGS_COMPILE"
    echo ""
  '';

  postInstall = ''
    mkdir -p $doc/share/doc
    unzip $docsrc
    mv sqlite-doc-${archiveVersion finalAttrs.version} $doc/share/doc/sqlite
  '';

  # SQLite’s tests are unreliable on Darwin. Sometimes they run successfully, but often they do not.
  # The tests are only defined for Darwin, Linux, Windows, and OpenBSD, not any other unix-like OS.
  doCheck = stdenv.hostPlatform.isLinux;
  # When tcl is not available, only run test targets that don't need it.
  checkTarget = lib.optionalString stdenv.hostPlatform.isStatic "fuzztest sourcetest";

  passthru = {
    tests = {
      inherit (python3Packages) sqlalchemy;
      inherit
        sqldiff
        sqlite-analyzer
        sqlite-rsync
        tinysparql
        ;
    };

    updateScript = gitUpdater {
      # No nicer place to look for latest version.
      url = "https://github.com/sqlite/sqlite.git";
      # Expect tags like "version-3.43.0".
      rev-prefix = "version-";
    };
  };

  __structuredAttrs = true;

  meta = {
    changelog = "https://www.sqlite.org/releaselog/${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.html";
    description = "Self-contained, serverless, zero-configuration, transactional SQL database engine";
    downloadPage = "https://sqlite.org/download.html";
    homepage = "https://www.sqlite.org/";
    license = lib.licenses.blessing;
    mainProgram = "sqlite3";
    maintainers = with lib.maintainers; [ np ];
    teams = [ lib.teams.security-review ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "sqlite3" ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "sqlite" finalAttrs.version;
  };
})
