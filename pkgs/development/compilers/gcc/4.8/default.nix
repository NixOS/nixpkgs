{ lib, stdenv, targetPackages, fetchurl, fetchpatch, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? stdenv.targetPlatform.isDarwin
, langObjCpp ? stdenv.targetPlatform.isDarwin
, langJava ? false
, langGo ? false
, reproducibleBuild ? true
, profiledCompiler ? false
, langJit ? false
, staticCompiler ? false
, enableShared ? !stdenv.targetPlatform.isStatic
, enableLTO ? !stdenv.hostPlatform.isStatic
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man); required for Java
, gmp, mpfr, libmpc, gettext, which, patchelf
, cloog ? null, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkg-config ? null
, gtk2 ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xorgproto ? null
, libXrandr ? null, libXi ? null
, x11Support ? langJava
, enableMultilib ? false
, enablePlugin ? stdenv.hostPlatform == stdenv.buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, threadsCross ? null # for MinGW
, crossStageStatic ? false
, gnused ? null
, buildPackages
}:

assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null
                       && perl != null;  # for `--enable-java-home'

# We enable the isl cloog backend.
assert cloog != null -> isl != null;

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

let majorVersion = "4";
    version = "${majorVersion}.8.5";

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches = [ ../parallel-bconfig.patch ]
      ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      ++ optional langFortran ../gfortran-driving.patch
      ++ optional hostPlatform.isDarwin ../gfortran-darwin-NXConstStr.patch
      ++ [(fetchpatch {
          name = "libc_name_p.diff"; # needed to build with gcc6
          url = "https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff_plain;h=ec1cc0263f1";
          sha256 = "01jd7pdarh54ki498g6sz64ijl9a1l5f9v8q2696aaxalvh2vwzl";
          excludes = [ "gcc/cp/ChangeLog" ];
        })]
      ++ [ # glibc-2.26
        ../struct-ucontext-4.8.patch
        ../sigsegv-not-declared.patch
        ../res_state-not-declared.patch
        # gcc-11 compatibility
        (fetchpatch {
          name = "gcc4-char-reload.patch";
          url = "https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff_plain;h=d57c99458933a21fdf94f508191f145ad8d5ec58";
          includes = [ "gcc/reload.h" ];
          sha256 = "sha256-66AMP7/ajunGKAN5WJz/yPn42URZ2KN51yPrFdsxEuM=";
        })
      ];

    javaEcj = fetchurl {
      # The `$(top_srcdir)/ecj.jar' file is automatically picked up at
      # `configure' time.

      # XXX: Eventually we might want to take it from upstream.
      url = "ftp://sourceware.org/pub/java/ecj-4.3.jar";
      sha256 = "0jz7hvc0s6iydmhgh5h2m15yza7p2rlss2vkif30vm9y77m97qcx";
    };

    # Antlr (optional) allows the Java `gjdoc' tool to be built.  We want a
    # binary distribution here to allow the whole chain to be bootstrapped.
    javaAntlr = fetchurl {
      url = "https://www.antlr.org/download/antlr-4.4-complete.jar";
      sha256 = "02lda2imivsvsis8rnzmbrbp8rh1kb8vmq4i67pqhkwz7lf8y6dz";
    };

    xlibs = [
      libX11 libXt libSM libICE libXtst libXrender libXrandr libXi
      xorgproto
    ];

    javaAwtGtk = langJava && x11Support;

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    stageNameAddon = if crossStageStatic then "stage-static" else "stage-final";
    crossNameAddon = optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-${stageNameAddon}-";

in

# We need all these X libraries when building AWT with GTK.
assert x11Support -> (filter (x: x == null) ([ gtk2 libart_lgpl ] ++ xlibs)) == [];

stdenv.mkDerivation ({
  pname = "${crossNameAddon}${name}";
  inherit version;

  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "08yggr18v373a1ihj0rg2vd6psnic42b518xcgp3r9k81xz1xyr2";
  };

  inherit patches;

  hardeningDisable = [ "format" "pie" ];

  outputs = [ "out" "lib" "man" "info" ];
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  postPatch =
    if targetPlatform != hostPlatform || stdenv.cc.libc != null then
      # On NixOS, use the right path to the dynamic linker instead of
      # `/lib/ld*.so'.
      let
        libc = if libcCross != null then libcCross else stdenv.cc.libc;
      in
        '' echo "fixing the \`GLIBC_DYNAMIC_LINKER' and \`UCLIBC_DYNAMIC_LINKER' macros..."
           for header in "gcc/config/"*-gnu.h "gcc/config/"*"/"*.h
           do
             grep -q LIBC_DYNAMIC_LINKER "$header" || continue
             echo "  fixing \`$header'..."
             sed -i "$header" \
                 -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc.out}\3"|g'
           done
        ''
    else null;

  inherit noSysDirs staticCompiler langJava crossStageStatic
    libcCross crossMingw;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ texinfo which gettext ]
    ++ (optional (perl != null) perl)
    ++ (optional javaAwtGtk pkg-config)
    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ (optional buildPlatform.isDarwin gnused)
    ;

  # For building runtime libs
  depsBuildTarget =
    (
      if hostPlatform == buildPlatform then [
        targetPackages.stdenv.cc.bintools # newly-built gcc will be used
      ] else assert targetPlatform == hostPlatform; [ # build != host == target
        stdenv.cc
      ]
    )
    ++ optional targetPlatform.isLinux patchelf;

  buildInputs = [
    gmp mpfr libmpc
    targetPackages.stdenv.cc.bintools # For linking code at run-time
  ] ++ (optional (cloog != null) cloog)
    ++ (optional (isl != null) isl)
    ++ (optional (zlib != null) zlib)
    ++ (optionals langJava [ boehmgc zip unzip ])
    ++ (optionals javaAwtGtk ([ gtk2 libart_lgpl ] ++ xlibs))
    ;

  depsTargetTarget = optional (!crossStageStatic && threadsCross != {}) threadsCross;

  preConfigure = import ../common/pre-configure.nix {
    inherit lib;
    inherit version targetPlatform hostPlatform buildPlatform langJava langGo crossStageStatic enableMultilib;
  };

  dontDisableStatic = true;

  configurePlatforms = [ "build" "host" "target" ];

  configureFlags = import ../common/configure-flags.nix {
    inherit
      lib
      stdenv
      targetPackages
      crossStageStatic libcCross threadsCross
      version

      gmp mpfr libmpc isl
      cloog

      enableLTO
      enableMultilib
      enablePlugin
      enableShared

      langC
      langCC
      langFortran
      langJava javaAwtGtk javaAntlr javaEcj
      langGo
      langObjC
      langObjCpp
      langJit
      ;
  };

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = optional
    (targetPlatform == hostPlatform && hostPlatform == buildPlatform)
    (if profiledCompiler then "profiledbootstrap" else "bootstrap");

  inherit
    (import ../common/strip-attributes.nix { inherit lib stdenv langJit; })
    stripDebugList
    stripDebugListTarget
    preFixup;

  doCheck = false; # requires a lot of tools, causes a dependency cycle for stdenv

  # https://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  ${if hostPlatform.system == "x86_64-solaris" then "CC" else null} = "gcc -m64";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
  # library headers and binaries, regarless of the language being compiled.
  #
  # Note: When building the Java AWT GTK peer, the build system doesn't honor
  # `--with-gmp' et al., e.g., when building
  # `libjava/classpath/native/jni/java-math/gnu_java_math_GMP.c', so we just add
  # them to $CPATH and $LIBRARY_PATH in this case.
  #
  # Likewise, the LTO code doesn't find zlib.
  #
  # Cross-compiling, we need gcc not to read ./specs in order to build the g++
  # compiler (after the specs for the cross-gcc are created). Having
  # LIBRARY_PATH= makes gcc read the specs from ., and the build breaks.

  CPATH = optionals (targetPlatform == hostPlatform) (makeSearchPathOutput "dev" "include" ([]
    ++ optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]
  ));

  LIBRARY_PATH = optionals (targetPlatform == hostPlatform) (makeLibraryPath ([]
    ++ optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]
  ));

  inherit
    (import ../common/extra-target-flags.nix {
      inherit lib stdenv crossStageStatic libcCross threadsCross;
    })
    EXTRA_FLAGS_FOR_TARGET
    EXTRA_LDFLAGS_FOR_TARGET
    ;

  passthru = {
    inherit langC langCC langObjC langObjCpp langFortran langGo version;
    isGNU = true;
    hardeningUnsupportedFlags = [ "stackprotector" ];
  };

  enableParallelBuilding = true;
  inherit enableShared enableMultilib;

  meta = {
    homepage = "https://gcc.gnu.org/";
    license = lib.licenses.gpl3Plus;  # runtime support libraries are typically LGPLv3+
    description = "GNU Compiler Collection, version ${version}";

    longDescription = ''
      The GNU Compiler Collection includes compiler front ends for C, C++,
      Objective-C, Fortran, OpenMP for C/C++/Fortran, Java, and Ada, as well
      as libraries for these languages (libstdc++, libgcj, libgomp,...).

      GCC development is a part of the GNU Project, aiming to improve the
      compiler used in the GNU system including the GNU/Linux variant.
    '';

    maintainers = with lib.maintainers; [ veprbl ];

    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}

// optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }
)
