{ lib, stdenv, targetPackages, fetchurl, fetchpatch, fetchFromGitHub, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langAda ? false
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
, flex
, perl ? null # optional, for texi2pod (then pod2man); required for Java
, gmp, mpfr, libmpc, gettext, which, patchelf, binutils
, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null, boehmgc ? null
, gnat-bootstrap ? null
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
, cloog ? null # unused; just for compat with gcc4, as we override the parameter on some places
, buildPackages
}:

assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null
                       && perl != null;  # for `--enable-java-home'

# Make sure we get GNU sed.
assert stdenv.buildPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;

assert langAda -> gnat-bootstrap != null;

# threadsCross is just for MinGW
assert threadsCross != {} -> stdenv.targetPlatform.isWindows;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

with lib;
with builtins;

let majorVersion = "6";
    version = "${majorVersion}.5.0";

    inherit (stdenv) buildPlatform hostPlatform targetPlatform;

    patches = [ ../9/fix-struct-redefinition-on-glibc-2.36.patch ]
    ++ optionals (!stdenv.targetPlatform.isRedox) [
      ../use-source-date-epoch.patch ./0001-Fix-build-for-glibc-2.31.patch

      # Fix https://gcc.gnu.org/bugzilla/show_bug.cgi?id=80431
      (fetchurl {
        name = "fix-bug-80431.patch";
        url = "https://gcc.gnu.org/git/?p=gcc.git;a=patch;h=de31f5445b12fd9ab9969dc536d821fe6f0edad0";
        sha256 = "0sd52c898msqg7m316zp0ryyj7l326cjcn2y19dcxqp15r74qj0g";
      })
    ] ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      ++ optional langAda ../gnat-cflags.patch
      ++ optional langAda ./gnat-glibc234.patch
      ++ optional langFortran ../gfortran-driving.patch
      ++ optional (targetPlatform.libc == "musl") ../libgomp-dont-force-initial-exec.patch
      ++ optional langGo ./gogcc-workaround-glibc-2.36.patch

      # Obtain latest patch with ../update-mcfgthread-patches.sh
      ++ optional (!crossStageStatic && targetPlatform.isMinGW && threadsCross.model == "mcf") ./Added-mcf-thread-model-support-from-mcfgthread.patch
      ++ optional (targetPlatform.libc == "musl" && targetPlatform.isx86_32) (fetchpatch {
        url = "https://git.alpinelinux.org/aports/plain/main/gcc/gcc-6.1-musl-libssp.patch?id=5e4b96e23871ee28ef593b439f8c07ca7c7eb5bb";
        sha256 = "1jf1ciz4gr49lwyh8knfhw6l5gvfkwzjy90m7qiwkcbsf4a3fqn2";
      })

      ++ [ ../libsanitizer-no-cyclades-9.patch ];

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

    callFile = lib.callPackageWith {
      # lets
      inherit
        majorVersion
        version
        buildPlatform
        hostPlatform
        targetPlatform
        patches
        javaEcj
        javaAntlr
        xlibs
        javaAwtGtk
        crossMingw
        stageNameAddon
        crossNameAddon
      ;
      # inherit generated with 'nix eval --json --impure --expr "with import ./. {}; lib.attrNames (lib.functionArgs gcc6.cc.override)" | jq '.[]' --raw-output'
      inherit
        binutils
        boehmgc
        buildPackages
        cloog
        crossStageStatic
        enableLTO
        enableMultilib
        enablePlugin
        enableShared
        fetchFromGitHub
        fetchpatch
        fetchurl
        flex
        gettext
        gmp
        gnat-bootstrap
        gnused
        gtk2
        isl
        langAda
        langC
        langCC
        langFortran
        langGo
        langJava
        langJit
        langObjC
        langObjCpp
        lib
        libICE
        libSM
        libX11
        libXi
        libXrandr
        libXrender
        libXt
        libXtst
        libart_lgpl
        libcCross
        libmpc
        mpfr
        name
        noSysDirs
        patchelf
        perl
        pkg-config
        profiledCompiler
        reproducibleBuild
        staticCompiler
        stdenv
        targetPackages
        texinfo
        threadsCross
        unzip
        which
        x11Support
        xorgproto
        zip
        zlib
      ;
    };
in

# We need all these X libraries when building AWT with GTK.
assert x11Support -> (filter (x: x == null) ([ gtk2 libart_lgpl ] ++ xlibs)) == [];

stdenv.mkDerivation ({
  pname = "${crossNameAddon}${name}";
  inherit version;

  builder = ../builder.sh;

  src = if stdenv.targetPlatform.isVc4 then fetchFromGitHub {
    owner = "itszor";
    repo = "gcc-vc4";
    rev = "e90ff43f9671c760cf0d1dd62f569a0fb9bf8918";
    sha256 = "0gxf66hwqk26h8f853sybphqa5ca0cva2kmrw5jsiv6139g0qnp8";
  } else if stdenv.targetPlatform.isRedox then fetchFromGitHub {
    owner = "redox-os";
    repo = "gcc";
    rev = "f360ac095028d286fc6dde4d02daed48f59813fa"; # `redox` branch
    sha256 = "1an96h8l58pppyh3qqv90g8hgcfd9hj7igvh2gigmkxbrx94khfl";
  } else fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "0i89fksfp6wr1xg9l8296aslcymv2idn60ip31wr9s4pwin7kwby";
  };

  inherit patches;

  outputs = if langJava || langGo || langJit then ["out" "man" "info"]
    else [ "out" "lib" "man" "info" ];
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  hardeningDisable = [ "format" "pie" ];

  postPatch =
    # This should kill all the stdinc frameworks that gcc and friends like to
    # insert into default search paths.
    lib.optionalString hostPlatform.isDarwin ''
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
    );

  inherit noSysDirs staticCompiler langJava crossStageStatic
    libcCross crossMingw;

  inherit (callFile ../common/dependencies.nix { })
    depsBuildBuild nativeBuildInputs depsBuildTarget buildInputs depsTargetTarget;

  NIX_LDFLAGS = lib.optionalString  hostPlatform.isSunOS "-lm";

  preConfigure = callFile ../common/pre-configure.nix { };

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

  inherit (callFile ../common/extra-target-flags.nix { })
    EXTRA_FLAGS_FOR_TARGET
    EXTRA_LDFLAGS_FOR_TARGET
    ;

  passthru = {
    inherit langC langCC langObjC langObjCpp langFortran langAda langGo version;
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

// optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }

// optionalAttrs (langJava && !stdenv.hostPlatform.isDarwin) {
     postFixup = ''
       target="$(echo "$out/libexec/gcc"/*/*/ecj*)"
       patchelf --set-rpath "$(patchelf --print-rpath "$target"):$out/lib" "$target"
     '';}
)
