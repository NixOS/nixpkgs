{ lib, stdenv, targetPackages, fetchurl, fetchpatch, fetchFromGitHub, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langAda ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin
, langD ? false
, langGo ? false
, reproducibleBuild ? true
, profiledCompiler ? false
, langJit ? false
, langRust ? false
, cargo
, staticCompiler ? false
, enableShared ? stdenv.targetPlatform.hasSharedLibraries
, enableLTO ? stdenv.hostPlatform.hasSharedLibraries
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man)
, gmp, mpfr, libmpc, gettext, which, patchelf, binutils
, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null
, libucontext ? null
, gnat-bootstrap ? null
, enableMultilib ? false
, enablePlugin ? stdenv.hostPlatform == stdenv.buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, threadsCross ? null # for MinGW
, withoutTargetLibc ? false
, gnused ? null
, buildPackages
, pkgsBuildTarget
, libxcrypt
, disableGdbPlugin ? !enablePlugin || (stdenv.targetPlatform.isAvr && stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
, nukeReferences
, callPackage
, majorMinorVersion
, cctools
, darwin
}:

let
  inherit (lib)
    callPackageWith
    filter
    getBin
    maintainers
    makeLibraryPath
    makeSearchPathOutput
    mapAttrs
    optional
    optionalAttrs
    optionals
    optionalString
    pipe
    platforms
    versionAtLeast
    versions
    ;

  gccVersions = import ./versions.nix;
  version = gccVersions.fromMajorMinor majorMinorVersion;

  majorVersion = versions.major version;
  atLeast14 = versionAtLeast version "14";
  atLeast13 = versionAtLeast version "13";
  atLeast12 = versionAtLeast version "12";
  atLeast11 = versionAtLeast version "11";
  atLeast10 = versionAtLeast version "10";
  atLeast9  = versionAtLeast version  "9";
  atLeast8  = versionAtLeast version  "8";
  is14 = majorVersion == "14";
  is13 = majorVersion == "13";
  is12 = majorVersion == "12";
  is11 = majorVersion == "11";
  is10 = majorVersion == "10";
  is9  = majorVersion == "9";
  is8  = majorVersion == "8";
  is7  = majorVersion == "7";

    disableBootstrap = atLeast11 && !stdenv.hostPlatform.isDarwin && (atLeast12 -> !profiledCompiler);

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;
    targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

    patches = callFile ./patches {};

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.isMinGW;
    stageNameAddon = optionalString withoutTargetLibc "-nolibc";
    crossNameAddon = optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}${stageNameAddon}-";

    callFile = callPackageWith {
      # lets
      inherit
        majorVersion
        version
        buildPlatform
        hostPlatform
        targetPlatform
        targetConfig
        patches
        crossMingw
        stageNameAddon
        crossNameAddon
      ;
      # inherit generated with 'nix eval --json --impure --expr "with import ./. {}; lib.attrNames (lib.functionArgs gcc${majorVersion}.cc.override)" | jq '.[]' --raw-output'
      inherit
        binutils
        buildPackages
        cargo
        withoutTargetLibc
        darwin
        disableBootstrap
        disableGdbPlugin
        enableLTO
        enableMultilib
        enablePlugin
        enableShared
        fetchpatch
        fetchurl
        gettext
        gmp
        gnat-bootstrap
        gnused
        isl
        langAda
        langC
        langCC
        langD
        langFortran
        langGo
        langJit
        langObjC
        langObjCpp
        langRust
        lib
        libcCross
        libmpc
        libucontext
        libxcrypt
        mpfr
        name
        noSysDirs
        nukeReferences
        patchelf
        perl
        pkgsBuildTarget
        profiledCompiler
        reproducibleBuild
        staticCompiler
        stdenv
        targetPackages
        texinfo
        threadsCross
        which
        zlib
      ;
    };

in

# Make sure we get GNU sed.
assert stdenv.buildPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;
assert (!is7 && !is8) -> (langAda -> gnat-bootstrap != null);

# TODO: fixup D bootstapping, probably by using gdc11 (and maybe other changes).
#   error: GDC is required to build d
assert atLeast12 -> !langD;

# threadsCross is just for MinGW
assert threadsCross != {} -> stdenv.targetPlatform.isWindows;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

pipe ((callFile ./common/builder.nix {}) ({
  pname = "${crossNameAddon}${name}";
  inherit version;

  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    ${if is10 || is11 || is13 then "hash" else "sha256"} =
      gccVersions.srcHashForVersion version;
  };

  inherit patches;

  outputs = [ "out" "man" "info" ] ++ optional (!langJit) "lib";

  setOutputFlags = false;

  libc_dev = stdenv.cc.libc_dev;

  hardeningDisable = [ "format" "pie" "stackclashprotection" ]
  ++ optionals (is11 && langAda) [ "fortify3" ];

  postPatch = ''
    configureScripts=$(find . -name configure)
    for configureScript in $configureScripts; do
      patchShebangs $configureScript
    done
  ''
  # This should kill all the stdinc frameworks that gcc and friends like to
  # insert into default search paths.
  + optionalString hostPlatform.isDarwin ''
    substituteInPlace gcc/config/darwin-c.c${optionalString atLeast12 "c"} \
      --replace 'if (stdinc)' 'if (0)'

    substituteInPlace libgcc/config/t-slibgcc-darwin \
      --replace "-install_name @shlib_slibdir@/\$(SHLIB_INSTALL_NAME)" "-install_name ''${!outputLib}/lib/\$(SHLIB_INSTALL_NAME)"

    substituteInPlace libgfortran/configure \
      --replace "-install_name \\\$rpath/\\\$soname" "-install_name ''${!outputLib}/lib/\\\$soname"
  ''
  + (
    optionalString (targetPlatform != hostPlatform || stdenv.cc.libc != null)
      # On NixOS, use the right path to the dynamic linker instead of
      # `/lib/ld*.so'.
      (let
        libc = if libcCross != null then libcCross else stdenv.cc.libc;
      in
        (
        '' echo "fixing the {GLIBC,UCLIBC,MUSL}_DYNAMIC_LINKER macros..."
           for header in "gcc/config/"*-gnu.h "gcc/config/"*"/"*.h
           do
             grep -q _DYNAMIC_LINKER "$header" || continue
             echo "  fixing $header..."
             sed -i "$header" \
                 -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc.out}\3"|g' \
                 -e 's|define[[:blank:]]*MUSL_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define MUSL_DYNAMIC_LINKER\1 "${libc.out}\2"|g'
             done
        '' + optionalString (targetPlatform.libc == "musl") ''
           sed -i gcc/config/linux.h -e '1i#undef LOCAL_INCLUDE_DIR'
        ''
        )
    ))
      + optionalString targetPlatform.isAvr (''
            makeFlagsArray+=(
               '-s' # workaround for hitting hydra log limit
               'LIMITS_H_TEST=false'
            )
          '');

  inherit noSysDirs staticCompiler withoutTargetLibc
    libcCross crossMingw;

  inherit (callFile ./common/dependencies.nix { }) depsBuildBuild nativeBuildInputs depsBuildTarget buildInputs depsTargetTarget;

  preConfigure = (callFile ./common/pre-configure.nix { }) + optionalString atLeast10 ''
    ln -sf ${libxcrypt}/include/crypt.h libsanitizer/sanitizer_common/crypt.h
  '';

  dontDisableStatic = true;

  configurePlatforms = [ "build" "host" "target" ];

  configureFlags = (callFile ./common/configure-flags.nix { })
    ++ optional (is7 && targetPlatform.isAarch64) "--enable-fix-cortex-a53-843419"
    ++ optional (is7 && targetPlatform.isNetBSD) "--disable-libcilkrts";

  inherit targetConfig;

  buildFlags =
    # we do not yet have Nix-driven profiling
    assert atLeast12 -> (profiledCompiler -> !disableBootstrap);
    if atLeast11
    then let target =
               optionalString (profiledCompiler) "profiled" +
               optionalString (targetPlatform == hostPlatform && hostPlatform == buildPlatform && !disableBootstrap) "bootstrap";
         in optional (target != "") target
    else
      optional
        (targetPlatform == hostPlatform && hostPlatform == buildPlatform)
        (if profiledCompiler then "profiledbootstrap" else "bootstrap");

  inherit (callFile ./common/strip-attributes.nix { })
    stripDebugList
    stripDebugListTarget
    preFixup;

  # https://gcc.gnu.org/PR109898
  enableParallelInstalling = false;

  env = mapAttrs (_: v: toString v) ({

    NIX_NO_SELF_RPATH = true;

    # https://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
    ${if hostPlatform.system == "x86_64-solaris" then "CC" else null} = "gcc -m64";

    # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
    # library headers and binaries, regarless of the language being compiled.
    #
    # The LTO code doesn't find zlib, so we just add it to $CPATH and
    # $LIBRARY_PATH in this case.
    #
    # Cross-compiling, we need gcc not to read ./specs in order to build the g++
    # compiler (after the specs for the cross-gcc are created). Having
    # LIBRARY_PATH= makes gcc read the specs from ., and the build breaks.

    CPATH = optionals (targetPlatform == hostPlatform) (makeSearchPathOutput "dev" "include" ([]
      ++ optional (zlib != null) zlib
    ));

    LIBRARY_PATH = optionals (targetPlatform == hostPlatform) (makeLibraryPath (
      optional (zlib != null) zlib
    ));

    NIX_LDFLAGS = optionalString hostPlatform.isSunOS "-lm";

    inherit (callFile ./common/extra-target-flags.nix { })
      EXTRA_FLAGS_FOR_TARGET
      EXTRA_LDFLAGS_FOR_TARGET
      ;
  } // optionalAttrs is7 {
    NIX_CFLAGS_COMPILE = optionalString (stdenv.cc.isClang && langFortran) "-Wno-unused-command-line-argument"
      # Downgrade register storage class specifier errors to warnings when building a cross compiler from a clang stdenv.
      + optionalString (stdenv.cc.isClang && targetPlatform != hostPlatform) " -Wno-register";
  } // optionalAttrs (!is7 && !atLeast12 && stdenv.cc.isClang && targetPlatform != hostPlatform) {
    NIX_CFLAGS_COMPILE = "-Wno-register";
  });

  passthru = {
    inherit langC langCC langObjC langObjCpp langAda langFortran langGo langD version;
    isGNU = true;
    hardeningUnsupportedFlags =
      optional (
        (targetPlatform.isAarch64 && !atLeast9) || !atLeast8
      ) "stackclashprotection"
      ++ optional (!atLeast11) "zerocallusedregs"
      ++ optionals (!atLeast12) [ "fortify3" "trivialautovarinit" ]
      ++ optional (!(
        atLeast8
        && targetPlatform.isLinux
        && targetPlatform.isx86_64
        && targetPlatform.libc == "glibc"
      )) "shadowstack"
      ++ optional (!(atLeast9 && targetPlatform.isLinux && targetPlatform.isAarch64)) "pacret"
      ++ optionals (langFortran) [ "fortify" "format" ];
  };

  enableParallelBuilding = true;
  inherit enableShared enableMultilib;

  meta = {
    inherit (callFile ./common/meta.nix { })
      homepage
      license
      description
      longDescription
      platforms
      maintainers
    ;
  } // optionalAttrs (!atLeast11) {
    badPlatforms =
      # avr-gcc8 is maintained for the `qmk` package
      if (is8 && targetPlatform.isAvr) then []
      else [ "aarch64-darwin" ];
  } // optionalAttrs is10 {
    badPlatforms = if targetPlatform != hostPlatform then [ "aarch64-darwin" ] else [ ];
  };
} // optionalAttrs (!atLeast10 && stdenv.targetPlatform.isDarwin) {
  # GCC <10 requires default cctools `strip` instead of `llvm-strip` used by Darwin bintools.
  preBuild = ''
    makeFlagsArray+=('STRIP=${getBin cctools}/bin/${stdenv.cc.targetPrefix}strip')
  '';
} // optionalAttrs (!atLeast8) {
  doCheck = false; # requires a lot of tools, causes a dependency cycle for stdenv
} // optionalAttrs enableMultilib {
  dontMoveLib64 = true;
}
))
([
  (callPackage ./common/libgcc.nix   { inherit version langC langCC langJit targetPlatform hostPlatform withoutTargetLibc enableShared libcCross; })
] ++ optionals atLeast11 [
  (callPackage ./common/checksum.nix { inherit langC langCC; })
])

