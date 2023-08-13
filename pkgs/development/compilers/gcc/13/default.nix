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
}:

# Make sure we get GNU sed.
assert stdenv.buildPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;
assert langAda -> gnat-bootstrap != null;

# TODO: fixup D bootstapping, probably by using gdc11 (and maybe other changes).
#   error: GDC is required to build d
assert !langD;

# threadsCross is just for MinGW
assert threadsCross != {} -> stdenv.targetPlatform.isWindows;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

with lib;
with builtins;

let majorVersion = "13";
    version = "${majorVersion}.1.0";
    disableBootstrap = !stdenv.hostPlatform.isDarwin && !profiledCompiler;

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches =
         optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../gcc-12-no-sys-dirs.patch
      ++ optional noSysDirs ../no-sys-dirs-riscv.patch
      ++ [
        ../gnat-cflags-11.patch
        ../gcc-12-gfortran-driving.patch
        ../ppc-musl.patch
      ]
      # We only apply this patch when building a native toolchain for aarch64-darwin, as it breaks building
      # a foreign one: https://github.com/iains/gcc-12-branch/issues/18
      ++ optional (stdenv.isDarwin && stdenv.isAarch64 && buildPlatform == hostPlatform && hostPlatform == targetPlatform) (fetchpatch {
        name = "gcc-13-darwin-aarch64-support.patch";
        url = "https://github.com/Homebrew/formula-patches/raw/5c206c47e2a08d522ec9795bb314346fff5fc4c5/gcc/gcc-13.1.0.diff";
        sha256 = "sha256-sMgA7nwE2ULa54t5g6VE6eJQYa69XvQrefi9U9f2t4g=";
      })
      ++ optional langD ../libphobos.patch

      # backport fixes to build gccgo with musl libc
      ++ optionals (langGo && stdenv.hostPlatform.isMusl) [
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
      ++ optional (stdenv.isDarwin && langAda) ../ada-cctools-as-detection-configure.patch

      # Use absolute path in GNAT dylib install names on Darwin
      ++ optional (stdenv.isDarwin && langAda) ../gnat-darwin-dylib-install-name.patch
    ;

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
      # inherit generated with 'nix eval --json --impure --expr "with import ./. {}; lib.attrNames (lib.functionArgs gcc13.cc.override)" | jq '.[]' --raw-output'
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
    };

in

lib.pipe ((callFile ../common/builder.nix {}) ({
  pname = "${crossNameAddon}${name}";
  inherit version;

  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "sha256-YdaE8Kpedqxlha2ImKJCeq3ol57V5/hUkihsTfwT7oY=";
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
    substituteInPlace gcc/config/darwin-c.cc \
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
      + lib.optionalString targetPlatform.isAvr ''
            makeFlagsArray+=(
               '-s' # workaround for hitting hydra log limit
               'LIMITS_H_TEST=false'
            )
          '';

  inherit noSysDirs staticCompiler withoutTargetLibc
    libcCross crossMingw;

  inherit (callFile ../common/dependencies.nix { }) depsBuildBuild nativeBuildInputs depsBuildTarget buildInputs depsTargetTarget;

  NIX_LDFLAGS = lib.optionalString  hostPlatform.isSunOS "-lm";


  preConfigure = (callFile ../common/pre-configure.nix { }) + ''
    ln -sf ${libxcrypt}/include/crypt.h libsanitizer/sanitizer_common/crypt.h
  '';

  dontDisableStatic = true;

  configurePlatforms = [ "build" "host" "target" ];

  configureFlags = callFile ../common/configure-flags.nix { };

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags =
    # we do not yet have Nix-driven profiling
    assert profiledCompiler -> !disableBootstrap;
    let target =
          lib.optionalString (profiledCompiler) "profiled" +
          lib.optionalString (targetPlatform == hostPlatform && hostPlatform == buildPlatform && !disableBootstrap) "bootstrap";
    in lib.optional (target != "") target;

  inherit (callFile ../common/strip-attributes.nix { })
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

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }
))
[
  (callPackage ../common/libgcc.nix   { inherit version langC langCC langJit targetPlatform hostPlatform withoutTargetLibc enableShared; })
  (callPackage ../common/checksum.nix { inherit langC langCC; })
]

