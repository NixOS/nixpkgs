{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
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

    patches = extraPatches;

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

    configureFlags = [
      (if cxxSupport then "--enable-cxx" else "--disable-cxx")
      (if compat185 then "--enable-compat185" else "--disable-compat185")
    ]
    ++ lib.optional dbmSupport "--enable-dbm"
    ++ lib.optional stdenv.hostPlatform.isFreeBSD "--with-pic";

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

    meta = with lib; {
      homepage = "https://www.oracle.com/database/technologies/related/berkeleydb.html";
      description = "Berkeley DB";
      license = license;
      platforms = platforms.unix;
    };
  }
  // drvArgs
)
