{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  getVersionFile,
  monorepoSrc ? null,
  fetchpatch,
  autoreconfHook269,
  runCommand,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libatomic";
  inherit version;

  src = runCommand "libatomic-src-${version}" { src = monorepoSrc; } (
    ''
      runPhase unpackPhase

      mkdir -p "$out/gcc"
      cp gcc/BASE-VER "$out/gcc"
      cp gcc/DATESTAMP "$out/gcc"

      cp -r libatomic "$out"

      cp -r config "$out"
      cp -r multilib.am "$out"
      cp -r libtool.m4 "$out"

      cp config.guess "$out"
      cp config.rpath "$out"
      cp config.sub "$out"
      cp config-ml.in "$out"
      cp ltmain.sh "$out"
      cp install-sh "$out"
      cp mkinstalldirs "$out"

    ''
    # `MD5SUMS` exists only in release tarballs, not in a VCS checkout.
    + ''
      if [[ -f MD5SUMS ]]; then cp MD5SUMS "$out"; fi
    ''
  );

  patches =
    lib.optionals (lib.versionAtLeast release_version "16") [
      (getVersionFile "libatomic/no-gcc-objdir-install.patch")
    ]
    # Both are the same upstream change, which is in the GCC 16 release
    # branch: the backport itself, and the hand-edit of the generated
    # `aclocal.m4` that `fetchpatch` cannot carry. GCC 16 already includes
    # `../config/gthr.m4` there.
    ++ lib.optionals (lib.versionOlder release_version "16") [
      (fetchpatch {
        name = "custom-threading-model.patch";
        url = "https://github.com/gcc-mirror/gcc/commit/e5d853bbe9b05d6a00d98ad236f01937303e40c4.diff";
        hash = "sha256-U1Eh6ByhmseHQigfHIyO4MlAQB3fECmpPEP/M00DOg0=";
        includes = [
          "config/*"
          "libatomic/configure.ac"
        ];
      })
      (getVersionFile "libatomic/gthr-include.patch")
    ];

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  preAutoreconf = ''
    sourceRoot=$(readlink -e "./libatomic")
    cd $sourceRoot
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook269
  ];

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--disable-dependency-tracking"
    "cross_compiling=true"
    "--disable-multilib"
  ];

  # GCC 16's `libatomic/configure.ac` refuses to run with an empty `CFLAGS`:
  # it appends `-fno-link-libatomic` to them and needs `AC_PROG_CC`'s conftests
  # to see it, so it will not let `AC_PROG_CC` supply the default instead. In
  # the monorepo build the top level passes them down; each library is
  # configured on its own here, so pass what `AC_PROG_CC` would have chosen.
  env = lib.optionalAttrs (lib.versionAtLeast release_version "16") {
    CFLAGS = "-g -O2";
  };

  preConfigure = ''
    cd "$buildRoot"
    configureScript=$sourceRoot/configure
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
