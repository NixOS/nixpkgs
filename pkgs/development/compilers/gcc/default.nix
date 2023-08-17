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
, cloog # unused; just for compat with gcc4, as we override the parameter on some places
, buildPackages
, libxcrypt
, disableGdbPlugin ? !enablePlugin
, nukeReferences
, callPackage
, version

# only for gcc<=6.x
, langJava ? false
, flex
, boehmgc ? null
, zip ? null, unzip ? null, pkg-config ? null
, gtk2 ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xorgproto ? null
, libXrandr ? null, libXi ? null
, x11Support ? langJava
}:

let
  atLeast13 = lib.versionAtLeast version "13";
  atLeast12 = lib.versionAtLeast version "12";
  atLeast11 = lib.versionAtLeast version "11";
  atLeast10 = lib.versionAtLeast version "10";
  atLeast9  = lib.versionAtLeast version  "9";
  atLeast8  = lib.versionAtLeast version  "8";
  atLeast7  = lib.versionAtLeast version  "7";
  atLeast6  = lib.versionAtLeast version  "6";
in

assert langJava -> !atLeast7 && zip != null && unzip != null && zlib != null && boehmgc != null && perl != null;  # for `--enable-java-home'

# only gcc>=6 is currently supported
assert atLeast6;

# Make sure we get GNU sed.
assert stdenv.buildPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;
assert (!atLeast7 || atLeast9) -> (langAda -> gnat-bootstrap != null);

# TODO: fixup D bootstapping, probably by using gdc11 (and maybe other changes).
#   error: GDC is required to build d
assert atLeast12 -> !langD;

# threadsCross is just for MinGW
assert threadsCross != {} -> stdenv.targetPlatform.isWindows;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

with lib;
with builtins;

let majorVersion = lib.versions.major version;
    inherit version;
    disableBootstrap = atLeast11 && !stdenv.hostPlatform.isDarwin && (atLeast12 -> !profiledCompiler);

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches =
      optionals (!atLeast7) [
        ./9/fix-struct-redefinition-on-glibc-2.36.patch
      ] ++ optionals (!atLeast7 && !stdenv.targetPlatform.isRedox) [
        ./use-source-date-epoch.patch
        ./6/0001-Fix-build-for-glibc-2.31.patch
      ] ++ optionals (atLeast7 && !atLeast8) [
        # https://gcc.gnu.org/ml/gcc-patches/2018-02/msg00633.html
        (./. + "/${majorVersion}/riscv-pthread-reentrant.patch")
        # https://gcc.gnu.org/ml/gcc-patches/2018-03/msg00297.html
        (./. + "/${majorVersion}/riscv-no-relax.patch")
        # Fix for asan w/glibc-2.34. Although there's no upstream backport to v7,
        # the patch from gcc 8 seems to work perfectly fine.
        (./. + "/${majorVersion}/gcc8-asan-glibc-2.34.patch")
      ] ++ optionals (atLeast7 && !atLeast8) [
        (./. + "/${majorVersion}/0001-Fix-build-for-glibc-2.31.patch")
      ] ++ optional (majorVersion == "9") ./9/fix-struct-redefinition-on-glibc-2.36.patch
      ++ optional (!atLeast12) ./fix-bug-80431.patch
      ++ optional (atLeast7 && !atLeast9) ./9/fix-struct-redefinition-on-glibc-2.36.patch
      ++ optional (atLeast10 && !atLeast11) ./11/fix-struct-redefinition-on-glibc-2.36.patch
      ++ optional (targetPlatform != hostPlatform) ./libstdc++-target.patch
      ++ optional (atLeast7 && !atLeast10 && targetPlatform.isNetBSD) ./libstdc++-netbsd-ctypes.patch
      ++ optional (noSysDirs &&  atLeast12) ./gcc-12-no-sys-dirs.patch
      ++ optional (noSysDirs && !atLeast12) ./no-sys-dirs.patch
      ++ optional (!atLeast7 && langAda) ./gnat-cflags.patch
      ++ optional (!atLeast7 && langAda) ./6/gnat-glibc234.patch
      ++ optional (noSysDirs && atLeast10 && (is10 || !atLeast12 -> hostPlatform.isRiscV)) ./no-sys-dirs-riscv.patch
      ++ optional (noSysDirs && atLeast9 && !atLeast10 && hostPlatform.isRiscV) ./no-sys-dirs-riscv-gcc9.patch
      ++ optionals (langAda || atLeast12) [
        ./gnat-cflags-11.patch
      ] ++ optionals (langAda && atLeast9 && !atLeast11) [
        ./gnat-cflags.patch
      ] ++ optionals atLeast12 [
        ./gcc-12-gfortran-driving.patch
        ./ppc-musl.patch
      ] ++ optionals (majorVersion == "12") [
        # backport ICE fix on ccache code
        ./12/lambda-ICE-PR109241.patch
      ]
      # We only apply this patch when building a native toolchain for aarch64-darwin, as it breaks building
      # a foreign one: https://github.com/iains/gcc-12-branch/issues/18
      ++ optionals (stdenv.isDarwin && stdenv.isAarch64 && buildPlatform == hostPlatform && hostPlatform == targetPlatform) ({
        "13" = [ (fetchpatch {
          name = "gcc-13-darwin-aarch64-support.patch";
          url = "https://raw.githubusercontent.com/Homebrew/formula-patches/3c5cbc8e9cf444a1967786af48e430588e1eb481/gcc/gcc-13.2.0.diff";
          sha256 = "sha256-Y5r3U3dwAFG6+b0TNCFd18PNxYu2+W/5zDbZ5cHvv+U=";
        }) ];
        "12" = [ (fetchurl {
          name = "gcc-12-darwin-aarch64-support.patch";
          url = "https://raw.githubusercontent.com/Homebrew/formula-patches/f1188b90d610e2ed170b22512ff7435ba5c891e2/gcc/gcc-12.3.0.diff";
          sha256 = "sha256-naL5ZNiurqfDBiPSU8PTbTmLqj25B+vjjiqc4fAFgYs=";
        }) ];
      }."${majorVersion}" or [])
      ++ optional (atLeast9 && langD) ./libphobos.patch
      ++ optional (atLeast7 && !atLeast8 && hostPlatform != buildPlatform) (fetchpatch { # XXX: Refine when this should be applied
        url = "https://git.busybox.net/buildroot/plain/package/gcc/7.1.0/0900-remove-selftests.patch?id=11271540bfe6adafbc133caf6b5b902a816f5f02";
        sha256 = "0mrvxsdwip2p3l17dscpc1x8vhdsciqw1z5q9i6p5g9yg1cqnmgs";
      })
      ++ optional langFortran ../gfortran-driving.patch

      # TODO: deduplicate this with copy above -- leaving duplicated for now in order to avoid changing eval results by reordering
      ++ optional (atLeast7 && !atLeast12 && targetPlatform.libc == "musl" && targetPlatform.isPower) ./ppc-musl.patch
      ++ optional (!atLeast8 && targetPlatform.libc == "musl" && targetPlatform.isx86_32) (fetchpatch {
        url = "https://git.alpinelinux.org/aports/plain/main/gcc/gcc-6.1-musl-libssp.patch?id=5e4b96e23871ee28ef593b439f8c07ca7c7eb5bb";
        sha256 = "1jf1ciz4gr49lwyh8knfhw6l5gvfkwzjy90m7qiwkcbsf4a3fqn2";
      })
      ++ optional (atLeast7 && !atLeast9 && targetPlatform.libc == "musl") ./libgomp-dont-force-initial-exec.patch
      ++ optional (!atLeast7 && langGo) ./gogcc-workaround-glibc-2.36.patch
      # TODO: deduplicate this with copy above -- leaving duplicated for now in order to avoid changing eval results by reordering
      ++ optionals (atLeast11 && !atLeast12 && stdenv.isDarwin) [
        (fetchpatch {
          # There are no upstream release tags in https://github.com/iains/gcc-11-branch.
          # ff4bf32 is the commit from https://github.com/gcc-mirror/gcc/releases/tag/releases%2Fgcc-11.4.0
          url = "https://github.com/iains/gcc-11-branch/compare/ff4bf326d03e750a8d4905ea49425fe7d15a04b8..gcc-11.4-darwin-r0.diff";
          hash = "sha256-6prPgR2eGVJs7vKd6iM1eZsEPCD1ShzLns2Z+29vlt4=";
        })
      ]
      # https://github.com/osx-cross/homebrew-avr/issues/280#issuecomment-1272381808
      ++ optional (atLeast11 && !atLeast12 && stdenv.isDarwin && targetPlatform.isAvr) ./avr-gcc-11.3-darwin.patch

      # backport fixes to build gccgo with musl libc
      ++ optionals (atLeast12 && langGo && stdenv.hostPlatform.isMusl) [
        (fetchpatch {
          excludes = [ "gcc/go/gofrontend/MERGE" ];
          url = "https://github.com/gcc-mirror/gcc/commit/cf79b1117bd177d3d4c6ed24b6fa243c3628ac2d.diff";
          hash = "sha256-mS5ZiYi5D8CpGXrWg3tXlbhp4o86ew1imCTwaHLfl+I=";
        })
        (fetchpatch {
          excludes = [ "gcc/go/gofrontend/MERGE" ];
          url = "https://github.com/gcc-mirror/gcc/commit/7f195a2270910a6ed08bd76e3a16b0a6503f9faf.diff";
          hash = "sha256-Ze/cFM0dQofKH00PWPDoklXUlwWhwA1nyTuiDAZ6FKo=";
        })
        (fetchpatch {
          excludes = [ "gcc/go/gofrontend/MERGE" ];
          url = "https://github.com/gcc-mirror/gcc/commit/762fd5e5547e464e25b4bee435db6df4eda0de90.diff";
          hash = "sha256-o28upwTcHAnHG2Iq0OewzwSBEhHs+XpBGdIfZdT81pk=";
        })
        (fetchpatch {
          excludes = [ "gcc/go/gofrontend/MERGE" ];
          url = "https://github.com/gcc-mirror/gcc/commit/e73d9fcafbd07bc3714fbaf8a82db71d50015c92.diff";
          hash = "sha256-1SjYCVHLEUihdON2TOC3Z2ufM+jf2vH0LvYtZL+c1Fo=";
        })
        (fetchpatch {
          excludes = [ "gcc/go/gofrontend/MERGE" ];
          url = "https://github.com/gcc-mirror/gcc/commit/b6c6a3d64f2e4e9347733290aca3c75898c44b2e.diff";
          hash = "sha256-RycJ3YCHd3MXtYFjxP0zY2Wuw7/C4bWoBAQtTKJZPOQ=";
        })
        (fetchpatch {
          excludes = [ "gcc/go/gofrontend/MERGE" ];
          url = "https://github.com/gcc-mirror/gcc/commit/2b1a604a9b28fbf4f382060bebd04adb83acc2f9.diff";
          hash = "sha256-WiBQG0Xbk75rHk+AMDvsbrm+dc7lDH0EONJXSdEeMGE=";
        })
        (fetchpatch {
          url = "https://github.com/gcc-mirror/gcc/commit/c86b726c048eddc1be320c0bf64a897658bee13d.diff";
          hash = "sha256-QSIlqDB6JRQhbj/c3ejlmbfWz9l9FurdSWxpwDebnlI=";
        })
      ]

      # Fix detection of bootstrap compiler Ada support (cctools as) on Nix Darwin
      ++ optional (atLeast12 && stdenv.isDarwin && langAda) ./ada-cctools-as-detection-configure.patch

      # Use absolute path in GNAT dylib install names on Darwin
      ++ optional (atLeast12 && stdenv.isDarwin && langAda) ./gnat-darwin-dylib-install-name.patch

      # Obtain latest patch with ../update-mcfgthread-patches.sh
      ++ optional (!atLeast13 && !withoutTargetLibc && targetPlatform.isMinGW && threadsCross.model == "mcf")
        ./Added-mcf-thread-model-support-from-mcfgthread.patch

      ++ optional (!atLeast9) ./libsanitizer-no-cyclades-9.patch

      # openjdk build fails without this on -march=opteron; is upstream in gcc12
      ++ optionals (majorVersion == "11") [ ./11/gcc-issue-103910.patch ]

      ++ optional (majorVersion == "10" && buildPlatform.system == "aarch64-darwin" && targetPlatform != buildPlatform) (fetchpatch {
        url = "https://raw.githubusercontent.com/richard-vd/musl-cross-make/5e9e87f06fc3220e102c29d3413fbbffa456fcd6/patches/gcc-${version}/0008-darwin-aarch64-self-host-driver.patch";
        sha256 = "sha256-XtykrPd5h/tsnjY1wGjzSOJ+AyyNLsfnjuOZ5Ryq9vA=";
      });

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    stageNameAddon = if withoutTargetLibc then "stage-static" else "stage-final";
    crossNameAddon = optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-${stageNameAddon}-";

    javaAwtGtk = langJava && x11Support;
    xlibs = [
      libX11 libXt libSM libICE libXtst libXrender libXrandr libXi
      xorgproto
    ];
    callFile = lib.callPackageWith ({
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
      # inherit generated with 'nix eval --json --impure --expr "with import ./. {}; lib.attrNames (lib.functionArgs gcc${majorVersion}.cc.override)" | jq '.[]' --raw-output'
      inherit
        binutils
        buildPackages
        cloog
        withoutTargetLibc
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
    } // lib.optionalAttrs (!atLeast7) {
      inherit
        boehmgc
        flex
        gnat-bootstrap
        gtk2
        langAda
        langJava
        libICE
        libSM
        libX11
        libXi
        libXrandr
        libXrender
        libXt
        libXtst
        libart_lgpl
        pkg-config
        unzip
        x11Support
        xorgproto
        javaAwtGtk
        xlibs
      ;
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
    });

in

# We need all these X libraries when building AWT with GTK.
assert !atLeast7 -> (x11Support -> (filter (x: x == null) ([ gtk2 libart_lgpl ] ++ xlibs)) == []);

lib.pipe ((callFile ./common/builder.nix {}) ({
  pname = "${crossNameAddon}${name}";
  inherit version;

  src = if !atLeast7 && stdenv.targetPlatform.isVc4 then fetchFromGitHub {
    owner = "itszor";
    repo = "gcc-vc4";
    rev = "e90ff43f9671c760cf0d1dd62f569a0fb9bf8918";
    sha256 = "0gxf66hwqk26h8f853sybphqa5ca0cva2kmrw5jsiv6139g0qnp8";
  } else if !atLeast7 && stdenv.targetPlatform.isRedox then fetchFromGitHub {
    owner = "redox-os";
    repo = "gcc";
    rev = "f360ac095028d286fc6dde4d02daed48f59813fa"; # `redox` branch
    sha256 = "1an96h8l58pppyh3qqv90g8hgcfd9hj7igvh2gigmkxbrx94khfl";
  } else (fetchurl {
    url = if atLeast7
          then "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz"
          else "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    ${if majorVersion == "11" then "hash" else "sha256"} = {
      "13.1.0" = "sha256-YdaE8Kpedqxlha2ImKJCeq3ol57V5/hUkihsTfwT7oY=";
      "12.3.0" = "sha256-lJpdT5nnhkIak7Uysi/6tVeN5zITaZdbka7Jet/ajDs=";
      "11.4.0" = "sha256-Py2yIrAH6KSiPNW6VnJu8I6LHx6yBV7nLBQCzqc6jdk=";
      "10.5.0" = "sha256-JRCVQ/30bzl8NHtdi3osflaUpaUczkucbh6opxyjB8E=";
      "9.5.0"  = "13ygjmd938m0wmy946pxdhz9i1wq7z4w10l6pvidak0xxxj9yxi7";
      "8.5.0"  = "0l7d4m9jx124xsk6xardchgy2k5j5l2b15q322k31f0va4d8826k";
      "7.5.0"  = "0qg6kqc5l72hpnj4vr6l0p69qav0rh4anlkk3y55540zy3klc6dq";
      "6.5.0"  = "0i89fksfp6wr1xg9l8296aslcymv2idn60ip31wr9s4pwin7kwby";
    }."${version}";
  });

  inherit patches;

  outputs =
    if atLeast7
    then [ "out" "man" "info" ] ++ lib.optional (!langJit) "lib"
    else if langJava || langGo || langJit then ["out" "man" "info"]
    else [ "out" "lib" "man" "info" ];

  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  hardeningDisable = [ "format" "pie" ]
  ++ lib.optionals (atLeast11 && !atLeast12 && langAda) [ "fortify3" ];

  postPatch = (lib.optionalString atLeast7 ''
    configureScripts=$(find . -name configure)
    for configureScript in $configureScripts; do
      patchShebangs $configureScript
    done
  '')
  # This should kill all the stdinc frameworks that gcc and friends like to
  # insert into default search paths.
  + lib.optionalString hostPlatform.isDarwin ''
    substituteInPlace gcc/config/darwin-c.c${lib.optionalString atLeast12 "c"} \
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
        )
    ))
      + lib.optionalString (atLeast7 && targetPlatform.isAvr) (''
            makeFlagsArray+=(
          '' + (lib.optionalString atLeast10 ''
               '-s' # workaround for hitting hydra log limit
          '') + ''
               'LIMITS_H_TEST=false'
            )
          '');

  inherit noSysDirs staticCompiler withoutTargetLibc
    libcCross crossMingw;

  inherit (callFile ./common/dependencies.nix { }) depsBuildBuild nativeBuildInputs depsBuildTarget buildInputs depsTargetTarget;

  NIX_LDFLAGS = lib.optionalString  hostPlatform.isSunOS "-lm";


  preConfigure = (callFile ./common/pre-configure.nix { }) + lib.optionalString atLeast10 ''
    ln -sf ${libxcrypt}/include/crypt.h libsanitizer/sanitizer_common/crypt.h
  '';

  dontDisableStatic = true;

  configurePlatforms = [ "build" "host" "target" ];

  configureFlags = (callFile ./common/configure-flags.nix { })
    ++ optional (atLeast7 && !atLeast8 && targetPlatform.isAarch64) "--enable-fix-cortex-a53-843419"
    ++ optional (atLeast7 && !atLeast8 && targetPlatform.isNetBSD) "--disable-libcilkrts";

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags =
    # we do not yet have Nix-driven profiling
    assert atLeast12 -> (profiledCompiler -> !disableBootstrap);
    if atLeast11
    then let target =
               lib.optionalString (profiledCompiler) "profiled" +
               lib.optionalString (targetPlatform == hostPlatform && hostPlatform == buildPlatform && !disableBootstrap) "bootstrap";
         in lib.optional (target != "") target
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

  LIBRARY_PATH = optionals (targetPlatform == hostPlatform) (makeLibraryPath (
    optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]
  ));

  inherit (callFile ./common/extra-target-flags.nix { })
    EXTRA_FLAGS_FOR_TARGET
    EXTRA_LDFLAGS_FOR_TARGET
    ;

  passthru = {
    inherit langC langCC langObjC langObjCpp langAda langFortran langGo langD version;
    isGNU = true;
  } // lib.optionalAttrs (!atLeast12) {
    hardeningUnsupportedFlags = [ "fortify3" ];
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
  } // lib.optionalAttrs (!atLeast11) {
    badPlatforms = [ "aarch64-darwin" ];
  };
} // optionalAttrs (atLeast7 && !atLeast8) {
  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.cc.isClang && langFortran) "-Wno-unused-command-line-argument";
} // optionalAttrs (!atLeast7) {
  env.langJava = langJava;
} // optionalAttrs (!atLeast8) {
  doCheck = false; # requires a lot of tools, causes a dependency cycle for stdenv
} // optionalAttrs (enableMultilib) {
  dontMoveLib64 = true;
} // optionalAttrs (!atLeast7 && langJava && !stdenv.hostPlatform.isDarwin) {
     postFixup = ''
       target="$(echo "$out/libexec/gcc"/*/*/ecj*)"
       patchelf --set-rpath "$(patchelf --print-rpath "$target"):$out/lib" "$target"
     '';
}
))
([
  (callPackage ./common/libgcc.nix   { inherit version langC langCC langJit targetPlatform hostPlatform withoutTargetLibc enableShared; })
] ++ optionals atLeast11 [
  (callPackage ./common/checksum.nix { inherit langC langCC; })
])

