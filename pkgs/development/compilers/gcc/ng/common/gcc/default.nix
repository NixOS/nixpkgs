{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  monorepoSrc ? null,
  fetchpatch,
  langAda ? false,
  langC ? true,
  langCC ? true,
  langFortran ? false,
  langGo ? false,
  langJava ? false,
  langObjC ? stdenv.targetPlatform.isDarwin,
  langObjCpp ? stdenv.targetPlatform.isDarwin,
  langJit ? false,
  enablePlugin ? lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform,
  runCommand,
  buildPackages,
  isl,
  zlib,
  gmp,
  libmpc,
  mpfr,
  perl,
  texinfo,
  which,
  gettext,
  getVersionFile,
  buildGccPackages,
  targetPackages,
  libc,
  bintools,
}:
let
  inherit (stdenv) targetPlatform hostPlatform;
  targetPrefix = lib.optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${targetPrefix}${if langFortran then "gfortran" else "gcc"}";
  inherit version;

  src = monorepoSrc;

  outputs = [
    "out"
    "man"
    "info"
  ];

  patches = [
    (fetchpatch {
      name = "for_each_path-functional-programming.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/f23bac62f46fc296a4d0526ef54824d406c3756c.diff";
      hash = "sha256-J7SrypmVSbvYUzxWWvK2EwEbRsfGGLg4vNZuLEe6Xe0=";
    })
    (fetchpatch {
      name = "find_a_program-separate-from-find_a_file.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-1-git@JohnEricson.me/raw";
      hash = "sha256-0gaWaeFZq+a8q7Bcr3eILNjHh1LfzL/Lz4F+W+H6XIU=";
    })
    (fetchpatch {
      name = "simplify-find_a_program-and-find_a_file.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-2-git@JohnEricson.me/raw";
      hash = "sha256-ojdyszxLGL+njHK4eAaeBkxAhFTDI57j6lGuAf0A+N0=";
    })
    (fetchpatch {
      name = "for_each_path-pass-machine-specific.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-3-git@JohnEricson.me/raw";
      hash = "sha256-C5jUSyNchmZcE8RTXc2dHfCqNKuBHeiouLruK9UooSM=";
    })
    (fetchpatch {
      name = "find_a_program-search-with-machine-prefix.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250822234120.1988059-4-git@JohnEricson.me/raw";
      hash = "sha256-MwcO4OXPlcdaSYivsh5ru+Cfq6qybeAtgCgTEPGYg40=";
    })

    (getVersionFile "gcc/fix-collect2-paths.diff")
  ];

  enableParallelBuilding = true;

  hardeningDisable = [
    "format" # Some macro-indirect formatting in e.g. libcpp
  ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    texinfo
    which
    gettext
  ]
  ++ lib.optional (perl != null) perl;

  buildInputs = [
    gmp
    libmpc
    mpfr
  ]
  ++ lib.optional (isl != null) isl
  ++ lib.optional (zlib != null) zlib;

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  postPatch = ''
    configureScripts=$(find . -name configure)
    for configureScript in $configureScripts; do
      patchShebangs $configureScript
    done

    patchShebangs libbacktrace/install-debuginfo-for-buildid.sh
    patchShebangs runtest
  ''
  # This should kill all the stdinc frameworks that gcc and friends like to
  # insert into default search paths.
  + lib.optionalString hostPlatform.isDarwin ''
    substituteInPlace gcc/config/darwin-c.c \
      --replace 'if (stdinc)' 'if (0)'
  '';

  preConfigure =
    # Don't built target libraries, because we want to build separately
    ''
      substituteInPlace configure \
        --replace 'noconfigdirs=""' 'noconfigdirs="$noconfigdirs $target_libraries"'
    ''
    # HACK: if host and target config are the same, but the platforms are
    # actually different we need to convince the configure script that it
    # is in fact building a cross compiler although it doesn't believe it.
    +
      lib.optionalString (targetPlatform.config == hostPlatform.config && targetPlatform != hostPlatform)
        ''
          substituteInPlace configure --replace is_cross_compiler=no is_cross_compiler=yes
        ''
    # Cannot configure from src dir
    + ''
      cd "$buildRoot"

      mkdir -p "$buildRoot/libbacktrace/.libs"
      cp ${buildGccPackages.libbacktrace}/lib/libbacktrace.a "$buildRoot/libbacktrace/.libs/libbacktrace.a"
      cp -r ${buildGccPackages.libbacktrace}/lib/*.la "$buildRoot/libbacktrace"
      cp -r ${buildGccPackages.libbacktrace.dev}/include/*.h "$buildRoot/libbacktrace"

      mkdir -p "$buildRoot/libiberty/pic"
      cp ${buildGccPackages.libiberty}/lib/libiberty.a "$buildRoot/libiberty"
      cp ${buildGccPackages.libiberty}/lib/libiberty_pic.a "$buildRoot/libiberty/pic/libiberty.a"
      touch "$buildRoot/libiberty/stamp-noasandir"
      touch "$buildRoot/libiberty/stamp-h"
      touch "$buildRoot/libiberty/stamp-picdir"

      mkdir -p "$buildRoot/build-${stdenv.hostPlatform.config}"
      cp -r "$buildRoot/libiberty" "$buildRoot/build-${stdenv.hostPlatform.config}/libiberty"

      configureScript=../$sourceRoot/configure
    '';

  # Don't store the configure flags in the resulting executables.
  postConfigure = ''
    sed -e '/TOPLEVEL_CONFIGURE_ARGUMENTS=/d' -i Makefile
  '';

  dontDisableStatic = true;

  configurePlatforms = [
    "build"
    "host"
    "target"
  ];

  configureFlags = [
    # Force target prefix. The behavior if `--target` and `--host` are
    # specified is inconsistent: Sometimes specifying `--target` always causes
    # a prefix to be generated, sometimes it's only added if the `--host` and
    # `--target` differ. This means that sometimes there may be a prefix even
    # though nixpkgs doesn't expect one and sometimes there may be none even
    # though nixpkgs expects one (since not all information is serialized into
    # the config attribute). The easiest way out of these problems is to always
    # set the program prefix, so gcc will conform to our expectations.
    "--program-prefix=${targetPrefix}"

    "--disable-dependency-tracking"
    "--enable-fast-install"
    "--disable-serial-configure"
    "--disable-bootstrap"
    "--disable-decimal-float"
    "--disable-install-libiberty"
    "--disable-multilib"
    "--disable-nls"
    "--disable-shared"
    "--enable-default-pie"
    "--enable-languages=${
      lib.concatStrings (
        lib.intersperse "," (
          lib.optional langC "c"
          ++ lib.optional langCC "c++"
          ++ lib.optional langFortran "fortran"
          ++ lib.optional langJava "java"
          ++ lib.optional langAda "ada"
          ++ lib.optional langGo "go"
          ++ lib.optional langObjC "objc"
          ++ lib.optional langObjCpp "obj-c++"
          ++ lib.optional langJit "jit"
        )
      )
    }"
    (lib.withFeature (isl != null) "isl")
    "--without-headers"
    "--with-gnu-as"
    "--with-gnu-ld"
    "--with-as=${lib.getExe' bintools "${bintools.targetPrefix}as"}"
    "--with-system-zlib"
    "--without-included-gettext"
    "--enable-linker-build-id"
    "--with-sysroot=${lib.getDev (targetPackages.libc or libc)}"
    "--with-native-system-header-dir=/include"
  ]
  ++ lib.optionals enablePlugin [
    "--enable-plugin"
    "--enable-plugins"
  ]
  ++
    # Only pass when the arch supports it.
    # Exclude RISC-V because GCC likes to fail when the string is empty on RISC-V.
    lib.optionals (targetPlatform.isAarch || targetPlatform.isAvr || targetPlatform.isx86_64) [
      "--with-multilib-list="
    ];

  doCheck = false;

  postInstall = ''
    moveToOutput "lib/gcc/${targetPlatform.config}/${version}/plugin/include" "''${!outputDev}"
  '';

  passthru = {
    inherit
      langC
      langCC
      langObjC
      langObjCpp
      langAda
      langFortran
      langGo
      ;
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
