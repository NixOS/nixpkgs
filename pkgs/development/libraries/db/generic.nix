{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  autoreconfHook,
  pthreads ? null,
  cxxSupport ? true,
  compat185 ? true,
  dbmSupport ? false,

  # Options from inherited versions
  version,
  sha256,
  extraPatches ? [ ],
  license ? lib.licenses.sleepycat,
  drvArgs ? { },
}:

stdenv.mkDerivation (
  rec {
    pname = "db";
    inherit version;

    src = fetchurl {
      url = "https://download.oracle.com/berkeley-db/db-${version}.tar.gz";
      sha256 = sha256;
    };

    # The provided configure script features `main` returning implicit `int`, which causes
    # configure checks to work incorrectly with clang 16.
    nativeBuildInputs = [ autoreconfHook ];

    patches = [
      (fetchpatch {
        name = "gcc15.patch";
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/db/files/db-4.8.30-tls-configure.patch?id=1ae36006c79ef705252f5f7009e79f6add7dc353";
        hash = "sha256-OzQL+kgXtcvhvyleDLuH1abhY4Shb/9IXx4ZkeFbHOA=";
      })
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      # On case-sensitive filesystems, the upstream header include uses the
      # wrong case. MinGW provides <winioctl.h>.
      ./mingw-winioctl-case.patch
    ]
    ++ extraPatches;

    outputs = [
      "bin"
      "out"
      "dev"
    ];

    # Required when regenerated the configure script to make sure the vendored macros are found.
    autoreconfFlags = [
      "-fi"
      "-Iaclocal"
      "-Iaclocal_java"
    ];

    preAutoreconf = ''
      pushd dist
      # Upstream’s `dist/s_config` cats everything into `aclocal.m4`, but that doesn’t work with
      # autoreconfHook, so cat `config.m4` to another file. Otherwise, it won’t be found by `aclocal`.
      cat aclocal/config.m4 >> aclocal/options.m4
    '';

    # This isn’t pretty. The version information is kept separate from the configure script.
    # After the configure script is regenerated, the version information has to be replaced with the
    # contents of `dist/RELEASE`.
    postAutoreconf = ''
      (
        declare -a vars=(
          "DB_VERSION_FAMILY"
          "DB_VERSION_RELEASE"
          "DB_VERSION_MAJOR"
          "DB_VERSION_MINOR"
          "DB_VERSION_PATCH"
          "DB_VERSION_STRING"
          "DB_VERSION_FULL_STRING"
          "DB_VERSION_UNIQUE_NAME"
          "DB_VERSION"
        )
        source RELEASE
        for var in "''${vars[@]}"; do
          sed -e "s/__EDIT_''${var}__/''${!var}/g" -i configure
        done
      )
      popd
    '';

    NIX_CFLAGS_COMPILE = [
      "-Wno-error=incompatible-pointer-types"
    ];

    configureFlags = [
      (if cxxSupport then "--enable-cxx" else "--disable-cxx")
      (if compat185 then "--enable-compat185" else "--disable-compat185")
    ]
    ++ lib.optional dbmSupport "--enable-dbm"
    # MSYS2 builds Berkeley DB for MinGW with --enable-mingw and winpthreads.
    # Without this, configure can incorrectly select removed UNIX/fcntl mutexes.
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      "--enable-mingw"
      # MSYS2 disables replication on MinGW; it is not needed for our consumers
      # and avoids building repmgr codepaths that are fragile with modern GCC.
      "--disable-replication"
    ]
    ++ lib.optional stdenv.hostPlatform.isFreeBSD "--with-pic";

    buildInputs = lib.optionals (stdenv.hostPlatform.isMinGW && pthreads != null) [
      # MSYS2 depends on libwinpthread for MinGW.
      pthreads
    ];

    env = lib.optionalAttrs (stdenv.hostPlatform.isMinGW && pthreads != null) {
      NIX_LDFLAGS = "-lpthread";
    };

    # When cross-compiling to MinGW, libtool's POSTLINK step tries to translate
    # a Unix-style PATH/LD_LIBRARY_PATH into a Windows host path and fails.
    # Override it to a no-op so db_* utilities can still be linked.
    makeFlags = lib.optionals (stdenv.hostPlatform.isMinGW && stdenv.buildPlatform != stdenv.hostPlatform) [
      "POSTLINK=true"
    ];

    preConfigure = ''
      cd build_unix
      configureScript=../dist/configure
    '';

    postInstall = ''
      rm -rf $out/docs
    '';

    enableParallelBuilding = true;

    doCheck = true;

    checkPhase = ''
      make examples_c examples_cxx
    '';

    meta = {
      homepage = "https://www.oracle.com/database/technologies/related/berkeleydb.html";
      description = "Berkeley DB";
      license = license;
      # MSYS2 ships mingw-w64-db, so allow evaluation/builds on Windows/MinGW.
      platforms = lib.platforms.unix ++ lib.platforms.windows;
    };
  }
  // drvArgs
)
