{ lib, stdenv, targetPackages, fetchurl, fetchpatch, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langAda ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin
, langD ? false
, langGo ? false
, reproducibleBuild ? true
, profiledCompiler ? false
, langJit ? false
, staticCompiler ? false
, enableShared ? !stdenv.targetPlatform.isStatic
, enableLTO ? !stdenv.hostPlatform.isStatic
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man)
, gmp, mpfr, libmpc, gettext, which, patchelf, binutils
, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null
, gnatboot ? null
, enableMultilib ? false
, enablePlugin ? stdenv.hostPlatform == stdenv.buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, threadsCross ? null # for MinGW
, crossStageStatic ? false
, gnused ? null
, cloog # unused; just for compat with gcc4, as we override the parameter on some places
, buildPackages
, libxcrypt
}:

# Make sure we get GNU sed.
assert stdenv.buildPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;
assert langAda -> gnatboot != null;

# threadsCross is just for MinGW
assert threadsCross != {} -> stdenv.targetPlatform.isWindows;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

with lib;
with builtins;

let majorVersion = "11";
    version = "${majorVersion}.3.0";

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches = [
      # Fix https://gcc.gnu.org/bugzilla/show_bug.cgi?id=80431
      (fetchurl {
        name = "fix-bug-80431.patch";
        url = "https://gcc.gnu.org/git/?p=gcc.git;a=patch;h=de31f5445b12fd9ab9969dc536d821fe6f0edad0";
        sha256 = "0sd52c898msqg7m316zp0ryyj7l326cjcn2y19dcxqp15r74qj0g";
      })
    ] ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      ++ optional (noSysDirs && hostPlatform.isRiscV) ../no-sys-dirs-riscv.patch
      /* ++ optional (hostPlatform != buildPlatform) (fetchpatch { # XXX: Refine when this should be applied
        url = "https://git.busybox.net/buildroot/plain/package/gcc/${version}/0900-remove-selftests.patch?id=11271540bfe6adafbc133caf6b5b902a816f5f02";
        sha256 = ""; # TODO: uncomment and check hash when available.
      }) */
      ++ optional langAda ../gnat-cflags-11.patch
      ++ optional langD ../libphobos.patch
      ++ optional langFortran ../gfortran-driving.patch
      ++ optional (targetPlatform.libc == "musl" && targetPlatform.isPower) ../ppc-musl.patch

      ++ optionals stdenv.isDarwin [
        (fetchpatch {
          # There are no upstream release tags in https://github.com/iains/gcc-11-branch.
          # 2d280e7 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-11.3.0
          url = "https://github.com/iains/gcc-11-branch/compare/2d280e7eafc086e9df85f50ed1a6526d6a3a204d..gcc-11.3-darwin-r2.diff";
          sha256 = "sha256-LFAXUEoYD7YeCG8V9mWanygyQOI7U5OhCRIKOVCCDAg=";
        })
      ]
      # https://github.com/osx-cross/homebrew-avr/issues/280#issuecomment-1272381808
      ++ optional (stdenv.isDarwin && targetPlatform.isAvr) ./avr-gcc-11.3-darwin.patch

      # Obtain latest patch with ../update-mcfgthread-patches.sh
      ++ optional (!crossStageStatic && targetPlatform.isMinGW && threadsCross.model == "mcf") ./Added-mcf-thread-model-support-from-mcfgthread.patch

      # openjdk build fails without this on -march=opteron; is upstream in gcc12
      ++ [ ./gcc-issue-103910.patch ];

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    stageNameAddon = if crossStageStatic then "stage-static" else "stage-final";
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
      # inherit generated with 'nix eval --json --impure --expr "with import ./. {}; lib.attrNames (lib.functionArgs gcc11.cc.override)" | jq '.[]' --raw-output'
      inherit
        binutils
        buildPackages
        cloog
        crossStageStatic
        enableLTO
        enableMultilib
        enablePlugin
        enableShared
        fetchpatch
        fetchurl
        gettext
        gmp
        gnatboot
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
        lib
        libcCross
        libmpc
        libxcrypt
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

stdenv.mkDerivation ({
  pname = "${crossNameAddon}${name}";
  inherit version;

  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "sha256-tHzygYaR9bHiHfK7OMeV+sLPvWQO3i0KXhyJ4zijrDk=";
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
               '-s' # workaround for hitting hydra log limit
               'LIMITS_H_TEST=false'
            )
          '';

  inherit noSysDirs staticCompiler crossStageStatic
    libcCross crossMingw;

  inherit (callFile ../common/dependencies.nix { })
    depsBuildBuild nativeBuildInputs depsBuildTarget buildInputs depsTargetTarget;

  NIX_LDFLAGS = lib.optionalString  hostPlatform.isSunOS "-lm";

  preConfigure = (callFile ../common/pre-configure.nix { }) + ''
    ln -sf ${libxcrypt}/include/crypt.h libsanitizer/sanitizer_common/crypt.h
  '';

  dontDisableStatic = true;

  configurePlatforms = [ "build" "host" "target" ];

  configureFlags = callFile ../common/configure-flags.nix { };

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = optional
    (targetPlatform == hostPlatform && hostPlatform == buildPlatform)
    (if profiledCompiler then "profiledbootstrap" else "bootstrap");

  inherit (callFile ../common/strip-attributes.nix { })
    stripDebugList
    stripDebugListTarget
    preFixup;

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
    inherit langC langCC langObjC langObjCpp langAda langFortran langGo langD version;
    isGNU = true;
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
  };
}

// optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }
)
