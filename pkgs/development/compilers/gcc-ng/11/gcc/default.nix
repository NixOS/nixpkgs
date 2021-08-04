{ lib, stdenv, targetPackages, fetchurl, fetchpatch
, gcc_tools_meta, gcc_src, version

, langAda ? false
, langC ? true
, langCC ? true
, langD ? false
, langFortran ? false
, langGo ? false
, langJava ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin

, reproducibleBuild ? true
, profiledCompiler ? false
, langJit ? false
, texinfo ? null
, perl ? null # lib.optional, for texi2pod (then pod2man)
, gmp, mpfr, libmpc, gettext, which, patchelf
, libelf                      # lib.optional, for link-time optimizations (LTO)
, isl ? null
, zlib ? null
, name ? "gcc"
, gnused ? null
, buildPackages
}:

# LTO needs libelf and zlib.
assert libelf != null -> zlib != null;

# Make sure we get GNU sed.
assert stdenv.hostPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

let
  inherit (stdenv) buildPlatform hostPlatform targetPlatform;
in

stdenv.mkDerivation ({
  pname = lib.optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-"
    + name;
  inherit version;

  src = gcc_src;

  patches = [
    ../../../gcc/no-sys-dirs.patch
  ] ++ lib.optional langFortran ../../gcc/gfortran-driving.patch
    ++ lib.optional (stdenv.isDarwin && stdenv.isAarch64) (fetchpatch {
      url = "https://github.com/fxcoudert/gcc/compare/releases/gcc-11.1.0...gcc-11.1.0-arm-20210504.diff";
      sha256 = "sha256-JqCGJAfbOxSmkNyq49aFHteK/RFsCSLQrL9mzUCnaD0=";
    })

    # Obtain latest patch with ../../gcc/update-mcfgthread-patches.sh
    ++ lib.optional targetPlatform.isMinGW ../../gcc/11/Added-mcf-thread-model-support-from-mcfgthread.patch;

  # TODO someday avoid target-specific subdirs all over the place and split libs from binaries
  outputs = [ "out" "dev" "man" "info" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ texinfo which gettext ]
    ++ lib.optional (perl != null) perl
    ;

  buildInputs = [
    gmp mpfr libmpc libelf
    #libiberty # TODO use prebuilt
  ] ++ lib.optional (isl != null) isl
    ++ lib.optional (zlib != null) zlib
    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ lib.optional hostPlatform.isDarwin gnused
    ;

  enableParallelBuilding = true;

  hardeningDisable = [
    "format" # Some macro-indirect formatting in e.g. libcpp
  ];

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  postPatch = ''
    configureScripts=$(find . -name configure)
    for configureScript in $configureScripts; do
      patchShebangs $configureScript
    done
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
    + lib.optionalString (targetPlatform.config == hostPlatform.config && targetPlatform != hostPlatform) ''
      substituteInPlace configure --replace is_cross_compiler=no is_cross_compiler=yes
    ''
    # Cannot configure from src dir
    + ''
      cd $buildRoot
      configureScript=../$sourceRoot/configure
    '';

  # Don't store the configure flags in the resulting executables.
  postConfigure = ''
    sed -e '/TOPLEVEL_CONFIGURE_ARGUMENTS=/d' -i Makefile
  '';

  # These flags confusingly control the runtime with GCC.
  dontDisableStatic = true;

  configurePlatforms = [ "build" "host" "target" ];

  configureFlags = [
    "--disable-dependency-tracking"
    "--enable-fast-install"
    "--disable-serial-configure"
    "--disable-bootstrap"
    "--disable-decimal-float"
    "--disable-install-libiberty"
    "--disable-multilib"
    "--disable-nls"
    "--disable-shared"
    "--enable-plugin"
    "--enable-plugins"
    "--enable-languages=${
      lib.concatStrings (lib.intersperse ","
        (  lib.optional langC        "c"
        ++ lib.optional langCC       "c++"
        ++ lib.optional langD        "d"
        ++ lib.optional langFortran  "fortran"
        ++ lib.optional langJava     "java"
        ++ lib.optional langAda      "ada"
        ++ lib.optional langGo       "go"
        ++ lib.optional langObjC     "objc"
        ++ lib.optional langObjCpp   "obj-c++"
        ++ lib.optional langJit      "jit"
        )
      )
    }"
    (lib.withFeature (isl != null) "isl")
    "--without-headers"
    "--with-gnu-as"
    "--with-gnu-ld"
    "--with-system-zlib"
    "--without-included-gettext"
    "--enable-linker-build-id"
    "--with-multilib-list="
  ];

  postInstall = ''
    moveToOutput "lib/gcc/${targetPlatform.config}/${version}/plugin/include" "$dev"
  '';

  passthru = {
    inherit langC langCC langObjC langObjCpp langAda langFortran langGo version;
    isGNU = true;
  };

  meta = gcc_tools_meta // {
    description = gcc_tools_meta.description + " - compiler proper";
  };
}

# // lib.optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
#   makeFlags = [ "all-gcc" "all-target-libgcc" ];
#   installTargets = "install-gcc install-target-libgcc";
# }
)
