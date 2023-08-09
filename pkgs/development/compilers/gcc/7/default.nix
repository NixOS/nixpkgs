{ lib, stdenv, targetPackages, fetchurl, fetchpatch, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin
, langGo ? false
, reproducibleBuild ? true
, profiledCompiler ? false
, langJit ? false
, staticCompiler ? false
, enableShared ? stdenv.targetPlatform.hasSharedLibraries
, enableLTO ? stdenv.hostPlatform.hasSharedLibraries
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man)
, gmp, mpfr, libmpc, gettext, which, patchelf, binutils
, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null
, enableMultilib ? false
, enablePlugin ? stdenv.hostPlatform == stdenv.buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, threadsCross ? null # for MinGW
, withoutTargetLibc ? false
, gnused ? null
, cloog ? null # unused; just for compat with gcc4, as we override the parameter on some places
, buildPackages
, callPackage
}:

# Make sure we get GNU sed.
assert stdenv.buildPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;

# threadsCross is just for MinGW
assert threadsCross != {} -> stdenv.targetPlatform.isWindows;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

with lib;
with builtins;

let majorVersion = "7";
    version = "${majorVersion}.5.0";

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches =
      [ # https://gcc.gnu.org/ml/gcc-patches/2018-02/msg00633.html
        ./riscv-pthread-reentrant.patch
        # https://gcc.gnu.org/ml/gcc-patches/2018-03/msg00297.html
        ./riscv-no-relax.patch
        # Fix for asan w/glibc-2.34. Although there's no upstream backport to v7,
        # the patch from gcc 8 seems to work perfectly fine.
        ./gcc8-asan-glibc-2.34.patch

        ./0001-Fix-build-for-glibc-2.31.patch

        # Fix https://gcc.gnu.org/bugzilla/show_bug.cgi?id=80431
        ../fix-bug-80431.patch

        ../9/fix-struct-redefinition-on-glibc-2.36.patch
      ]
      ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optionals targetPlatform.isNetBSD [
        ../libstdc++-netbsd-ctypes.patch
      ]
      ++ optional noSysDirs ../no-sys-dirs.patch
      ++ optional (hostPlatform != buildPlatform) (fetchpatch { # XXX: Refine when this should be applied
        url = "https://git.busybox.net/buildroot/plain/package/gcc/7.1.0/0900-remove-selftests.patch?id=11271540bfe6adafbc133caf6b5b902a816f5f02";
        sha256 = "0mrvxsdwip2p3l17dscpc1x8vhdsciqw1z5q9i6p5g9yg1cqnmgs";
      })
      ++ optional langFortran ../gfortran-driving.patch
      ++ optional (targetPlatform.libc == "musl" && targetPlatform.isPower) ../ppc-musl.patch
      ++ optional (targetPlatform.libc == "musl" && targetPlatform.isx86_32) (fetchpatch {
        url = "https://git.alpinelinux.org/aports/plain/main/gcc/gcc-6.1-musl-libssp.patch?id=5e4b96e23871ee28ef593b439f8c07ca7c7eb5bb";
        sha256 = "1jf1ciz4gr49lwyh8knfhw6l5gvfkwzjy90m7qiwkcbsf4a3fqn2";
      })
      ++ optional (targetPlatform.libc == "musl") ../libgomp-dont-force-initial-exec.patch

      # Obtain latest patch with ../update-mcfgthread-patches.sh
      ++ optional (!withoutTargetLibc && targetPlatform.isMinGW && threadsCross.model == "mcf") ./Added-mcf-thread-model-support-from-mcfgthread.patch

      ++ [ ../libsanitizer-no-cyclades-9.patch ];

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    stageNameAddon = if withoutTargetLibc then "stage-static" else "stage-final";
    crossNameAddon = optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-${stageNameAddon}-";

    callFile = lib.callPackageWith {
      # lets
      inherit
        majorVersion
        version
        buildPlatform
        hostPlatform
        targetPlatform
        patches
        crossMingw
        stageNameAddon
        crossNameAddon
      ;
      # inherit generated with 'nix eval --json --impure --expr "with import ./. {}; lib.attrNames (lib.functionArgs gcc7.cc.override)" | jq '.[]' --raw-output'
      inherit
        binutils
        buildPackages
        cloog
        withoutTargetLibc
        enableLTO
        enableMultilib
        enablePlugin
        enableShared
        fetchpatch
        fetchurl
        gettext
        gmp
        gnused
        isl
        langC
        langCC
        langFortran
        langGo
        langJit
        langObjC
        langObjCpp
        lib
        libcCross
        libmpc
        mpfr
        name
        noSysDirs
        patchelf
        perl
        profiledCompiler
        reproducibleBuild
        staticCompiler
        stdenv
        targetPackages
        texinfo
        threadsCross
        which
        zip
        zlib
      ;
    };

in

lib.pipe ((callFile ../common/builder.nix {}) ({
  pname = "${crossNameAddon}${name}";
  inherit version;

  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "0qg6kqc5l72hpnj4vr6l0p69qav0rh4anlkk3y55540zy3klc6dq";
  };

  inherit patches;

  outputs = [ "out" "man" "info" ] ++ lib.optional (!langJit) "lib";
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  hardeningDisable = [ "format" "pie" ];

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

    substituteInPlace libgcc/config/t-slibgcc-darwin \
      --replace "-install_name @shlib_slibdir@/\$(SHLIB_INSTALL_NAME)" "-install_name ''${!outputLib}/lib/\$(SHLIB_INSTALL_NAME)"

    substituteInPlace libgfortran/configure \
      --replace "-install_name \\\$rpath/\\\$soname" "-install_name ''${!outputLib}/lib/\\\$soname"
  ''
  + (
    lib.optionalString (targetPlatform != hostPlatform || stdenv.cc.libc != null)
      # On NixOS, use the right path to the dynamic linker instead of
      # `/lib/ld*.so'.
      (let
        libc = if libcCross != null then libcCross else stdenv.cc.libc;
      in
        (
        '' echo "fixing the \`GLIBC_DYNAMIC_LINKER', \`UCLIBC_DYNAMIC_LINKER', and \`MUSL_DYNAMIC_LINKER' macros..."
           for header in "gcc/config/"*-gnu.h "gcc/config/"*"/"*.h
           do
             grep -q _DYNAMIC_LINKER "$header" || continue
             echo "  fixing \`$header'..."
             sed -i "$header" \
                 -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc.out}\3"|g' \
                 -e 's|define[[:blank:]]*MUSL_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define MUSL_DYNAMIC_LINKER\1 "${libc.out}\2"|g'
           done
        ''
        + lib.optionalString (targetPlatform.libc == "musl")
        ''
            sed -i gcc/config/linux.h -e '1i#undef LOCAL_INCLUDE_DIR'
        ''
        ))
    )
      + lib.optionalString targetPlatform.isAvr ''
        makeFlagsArray+=(
           'LIMITS_H_TEST=false'
        )
      '';

  inherit noSysDirs staticCompiler withoutTargetLibc
    libcCross crossMingw;

  inherit (callFile ../common/dependencies.nix { })
    depsBuildBuild nativeBuildInputs depsBuildTarget buildInputs depsTargetTarget;

  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.cc.isClang && langFortran) "-Wno-unused-command-line-argument";
  NIX_LDFLAGS = lib.optionalString  hostPlatform.isSunOS "-lm";

  preConfigure = callFile ../common/pre-configure.nix { };

  dontDisableStatic = true;

  configurePlatforms = [ "build" "host" "target" ];

  configureFlags = (callFile ../common/configure-flags.nix { })
    ++ optional (targetPlatform.isAarch64) "--enable-fix-cortex-a53-843419"
    ++ optional targetPlatform.isNetBSD "--disable-libcilkrts"
  ;

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = optional
    (targetPlatform == hostPlatform && hostPlatform == buildPlatform)
    (if profiledCompiler then "profiledbootstrap" else "bootstrap");

  # https://gcc.gnu.org/PR109898
  enableParallelInstalling = false;

  inherit (callFile ../common/strip-attributes.nix { })
    stripDebugList
    stripDebugListTarget
    preFixup;

  doCheck = false; # requires a lot of tools, causes a dependency cycle for stdenv

  # https://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  ${if hostPlatform.system == "x86_64-solaris" then "CC" else null} = "gcc -m64";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
  # library headers and binaries, regarless of the language being compiled.
  #
  # Likewise, the LTO code doesn't find zlib.
  #
  # Cross-compiling, we need gcc not to read ./specs in order to build the g++
  # compiler (after the specs for the cross-gcc are created). Having
  # LIBRARY_PATH= makes gcc read the specs from ., and the build breaks.

  CPATH = optionals (targetPlatform == hostPlatform) (makeSearchPathOutput "dev" "include" ([]
    ++ optional (zlib != null) zlib
  ));

  LIBRARY_PATH = optionals (targetPlatform == hostPlatform) (makeLibraryPath (optional (zlib != null) zlib));

  inherit (callFile ../common/extra-target-flags.nix { })
    EXTRA_FLAGS_FOR_TARGET
    EXTRA_LDFLAGS_FOR_TARGET
    ;

  passthru = {
    inherit langC langCC langObjC langObjCpp langFortran langGo version;
    isGNU = true;
    hardeningUnsupportedFlags = [ "fortify3" ];
  };

  enableParallelBuilding = true;
  inherit enableShared enableMultilib;

  meta = {
    inherit (callFile ../common/meta.nix { })
      homepage
      license
      description
      longDescription
      platforms
      maintainers
    ;
    badPlatforms = [ "aarch64-darwin" ];
  };
}

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }
))
[
  (callPackage ../common/libgcc.nix   { inherit version langC langCC langJit targetPlatform hostPlatform withoutTargetLibc enableShared; })
]
