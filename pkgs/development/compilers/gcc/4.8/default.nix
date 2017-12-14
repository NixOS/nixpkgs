{ stdenv, targetPackages, fetchurl, fetchpatch, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? targetPlatform.isDarwin
, langObjCpp ? targetPlatform.isDarwin
, langJava ? false
, langAda ? false
, langVhdl ? false
, langGo ? false
, profiledCompiler ? false
, staticCompiler ? false
, enableShared ? true
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man); required for Java
, gmp, mpfr, libmpc, gettext, which
, libelf                      # optional, for link-time optimizations (LTO)
, cloog ? null, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkgconfig ? null
, gtk2 ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xproto ? null, renderproto ? null, xextproto ? null
, libXrandr ? null, libXi ? null, inputproto ? null, randrproto ? null
, x11Support ? langJava
, gnatboot ? null
, enableMultilib ? false
, enablePlugin ? hostPlatform == buildPlatform # Whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, crossStageStatic ? false
, gnat ? null
, libpthread ? null, libpthreadCross ? null  # required for GNU/Hurd
, stripped ? true
, gnused ? null
, darwin ? null
, buildPlatform, hostPlatform, targetPlatform
, buildPackages
}:

assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null
                       && perl != null;  # for `--enable-java-home'
assert langAda      -> gnatboot != null;
assert langVhdl     -> gnat != null;

# We enable the isl cloog backend.
assert cloog != null -> isl != null;

# LTO needs libelf and zlib.
assert libelf != null -> zlib != null;

# Make sure we get GNU sed.
assert hostPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;

with stdenv.lib;
with builtins;

let version = "4.8.5";

    # Whether building a cross-compiler for GNU/Hurd.
    crossGNU = targetPlatform != hostPlatform && targetPlatform.config == "i586-pc-gnu";

    enableParallelBuilding = true;

    patches = [ ]
      ++ optional enableParallelBuilding ../parallel-bconfig.patch
      ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      # The GNAT Makefiles did not pay attention to CFLAGS_FOR_TARGET for its
      # target libraries and tools.
      ++ optional langAda ../gnat-cflags.patch
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
      url = http://www.antlr.org/download/antlr-4.4-complete.jar;
      sha256 = "02lda2imivsvsis8rnzmbrbp8rh1kb8vmq4i67pqhkwz7lf8y6dz";
    };

    xlibs = [
      libX11 libXt libSM libICE libXtst libXrender libXrandr libXi
      xproto renderproto xextproto inputproto randrproto
    ];

    javaAwtGtk = langJava && x11Support;

    /* Platform flags */
    platformFlags = let
        gccArch = targetPlatform.platform.gcc.arch or null;
        gccCpu = targetPlatform.platform.gcc.cpu or null;
        gccAbi = targetPlatform.platform.gcc.abi or null;
        gccFpu = targetPlatform.platform.gcc.fpu or null;
        gccFloat = targetPlatform.platform.gcc.float or null;
        gccMode = targetPlatform.platform.gcc.mode or null;
      in
        optional (gccArch != null) "--with-arch=${gccArch}" ++
        optional (gccCpu != null) "--with-cpu=${gccCpu}" ++
        optional (gccAbi != null) "--with-abi=${gccAbi}" ++
        optional (gccFpu != null) "--with-fpu=${gccFpu}" ++
        optional (gccFloat != null) "--with-float=${gccFloat}" ++
        optional (gccMode != null) "--with-mode=${gccMode}";

    /* Cross-gcc settings (build == host != target) */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    crossDarwin = targetPlatform != hostPlatform && targetPlatform.libc == "libSystem";
    crossConfigureFlags =
      # Ensure that -print-prog-name is able to find the correct programs.
      [ "--with-as=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-as"
        "--with-ld=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-ld" ] ++
      (if crossMingw && crossStageStatic then [
        "--with-headers=${libcCross}/include"
        "--with-gcc"
        "--with-gnu-as"
        "--with-gnu-ld"
        "--with-gnu-ld"
        "--disable-shared"
        "--disable-nls"
        "--disable-debug"
        "--enable-sjlj-exceptions"
        "--enable-threads=win32"
        "--disable-win32-registry"
      ] else if crossStageStatic then [
        "--disable-libssp"
        "--disable-nls"
        "--without-headers"
        "--disable-threads"
        "--disable-libgomp"
        "--disable-libquadmath"
        "--disable-shared"
        "--disable-libatomic"  # libatomic requires libc
        "--disable-decimal-float" # libdecnumber requires libc
      ] else [
        (if crossDarwin then "--with-sysroot=${getLib libcCross}/share/sysroot"
         else                "--with-headers=${getDev libcCross}/include")
        "--enable-__cxa_atexit"
        "--enable-long-long"
      ] ++
        (if crossMingw then [
          "--enable-threads=win32"
          "--enable-sjlj-exceptions"
          "--enable-hash-synchronization"
          "--disable-libssp"
          "--disable-nls"
          "--with-dwarf2"
          # I think noone uses shared gcc libs in mingw, so we better do the same.
          # In any case, mingw32 g++ linking is broken by default with shared libs,
          # unless adding "-lsupc++" to any linking command. I don't know why.
          "--disable-shared"
          # To keep ABI compatibility with upstream mingw-w64
          "--enable-fully-dynamic-string"
        ] else
          optionals (targetPlatform.libc == "uclibc") [
            # In uclibc cases, libgomp needs an additional '-ldl'
            # and as I don't know how to pass it, I disable libgomp.
            "--disable-libgomp"
          ] ++ [
          "--enable-threads=posix"
          "--enable-nls"
          "--disable-decimal-float" # No final libdecnumber (it may work only in 386)
        ]));
    stageNameAddon = if crossStageStatic then "-stage-static" else "-stage-final";
    crossNameAddon = if targetPlatform != hostPlatform then "-${targetPlatform.config}" + stageNameAddon else "";

    bootstrap = targetPlatform == hostPlatform;

in

# We need all these X libraries when building AWT with GTK+.
assert x11Support -> (filter (x: x == null) ([ gtk2 libart_lgpl ] ++ xlibs)) == [];

stdenv.mkDerivation ({
  name = "${name}${if stripped then "" else "-debug"}-${version}" + crossNameAddon;

  builder = ../builder.sh;

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "08yggr18v373a1ihj0rg2vd6psnic42b518xcgp3r9k81xz1xyr2";
  };

  inherit patches;

  hardeningDisable = [ "format" ];

  outputs = [ "out" "lib" "man" "info" ];
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  postPatch =
    if (hostPlatform.isHurd
        || (libcCross != null                  # e.g., building `gcc.crossDrv'
            && libcCross ? crossConfig
            && libcCross.crossConfig == "i586-pc-gnu")
        || (crossGNU && libcCross != null))
    then
      # On GNU/Hurd glibc refers to Hurd & Mach headers and libpthread is not
      # in glibc, so add the right `-I' flags to the default spec string.
      assert libcCross != null -> libpthreadCross != null;
      let
        libc = if libcCross != null then libcCross else stdenv.glibc;
        gnu_h = "gcc/config/gnu.h";
        extraCPPDeps =
             libc.propagatedBuildInputs
          ++ stdenv.lib.optional (libpthreadCross != null) libpthreadCross
          ++ stdenv.lib.optional (libpthread != null) libpthread;
        extraCPPSpec =
          concatStrings (intersperse " "
                          (map (x: "-I${x.dev or x}/include") extraCPPDeps));
        extraLibSpec =
          if libpthreadCross != null
          then "-L${libpthreadCross}/lib ${libpthreadCross.TARGET_LDFLAGS}"
          else "-L${libpthread}/lib";
      in
        '' echo "augmenting \`CPP_SPEC' in \`${gnu_h}' with \`${extraCPPSpec}'..."
           sed -i "${gnu_h}" \
               -es'|CPP_SPEC *"\(.*\)$|CPP_SPEC "${extraCPPSpec} \1|g'

           echo "augmenting \`LIB_SPEC' in \`${gnu_h}' with \`${extraLibSpec}'..."
           sed -i "${gnu_h}" \
               -es'|LIB_SPEC *"\(.*\)$|LIB_SPEC "${extraLibSpec} \1|g'

           echo "setting \`NATIVE_SYSTEM_HEADER_DIR' and \`STANDARD_INCLUDE_DIR' to \`${libc.dev}/include'..."
           sed -i "${gnu_h}" \
               -es'|#define STANDARD_INCLUDE_DIR.*$|#define STANDARD_INCLUDE_DIR "${libc.dev}/include"|g'
        ''
    else if targetPlatform != hostPlatform || stdenv.cc.libc != null then
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

  # TODO(@Ericson2314): Make passthru instead. Weird to avoid mass rebuild,
  crossStageStatic = targetPlatform == hostPlatform || crossStageStatic;
  inherit noSysDirs staticCompiler langJava
    libcCross crossMingw;

  nativeBuildInputs = [ texinfo which gettext ]
    ++ (optional (perl != null) perl)
    ++ (optional javaAwtGtk pkgconfig);

  buildInputs = [ gmp mpfr libmpc libelf ]
    ++ (optional (cloog != null) cloog)
    ++ (optional (isl != null) isl)
    ++ (optional (zlib != null) zlib)
    ++ (optionals langJava [ boehmgc zip unzip ])
    ++ (optionals javaAwtGtk ([ gtk2 libart_lgpl ] ++ xlibs))
    ++ (optionals (targetPlatform != hostPlatform) [targetPackages.stdenv.cc.bintools])
    ++ (optionals langAda [gnatboot])
    ++ (optionals langVhdl [gnat])

    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ (optional hostPlatform.isDarwin gnused)
    ;


  preConfigure = stdenv.lib.optionalString (hostPlatform.isSunOS && hostPlatform.is64bit) ''
    export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
    export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
    export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
    export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
  '';

  dontDisableStatic = true;

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms =
    # TODO(@Ericson2314): Figure out what's going wrong with Arm
    if hostPlatform == targetPlatform && targetPlatform.isArm
    then []
    else [ "build" "host" ] ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";

  configureFlags =
    # Basic dependencies
    [
      "--with-gmp-include=${gmp.dev}/include"
      "--with-gmp-lib=${gmp.out}/lib"
      "--with-mpfr-include=${mpfr.dev}/include"
      "--with-mpfr-lib=${mpfr.out}/lib"
      "--with-mpc=${libmpc}"
    ] ++
    optional (libelf != null) "--with-libelf=${libelf}" ++
    optional (!(crossMingw && crossStageStatic))
      "--with-native-system-header-dir=${getDev stdenv.cc.libc}/include" ++

    # Basic configuration
    [
      "--enable-lto"
      "--disable-libstdcxx-pch"
      "--without-included-gettext"
      "--with-system-zlib"
      "--enable-static"
      "--enable-languages=${
        concatStrings (intersperse ","
          (  optional langC        "c"
          ++ optional langCC       "c++"
          ++ optional langFortran  "fortran"
          ++ optional langJava     "java"
          ++ optional langAda      "ada"
          ++ optional langVhdl     "vhdl"
          ++ optional langGo       "go"
          ++ optional langObjC     "objc"
          ++ optional langObjCpp   "obj-c++"
          ++ optionals crossDarwin [ "objc" "obj-c++" ]
          )
        )
      }"
    ] ++

    (if enableMultilib
      then ["--enable-multilib" "--disable-libquadmath"]
      else ["--disable-multilib"]) ++
    optional (!enableShared) "--disable-shared" ++
    (if enablePlugin
      then ["--enable-plugin"]
      else ["--disable-plugin"]) ++

    # Optional features
    optional (isl != null) "--with-isl=${isl}" ++
    optionals (cloog != null) [
      "--with-cloog=${cloog}"
      "--disable-cloog-version-check"
      "--enable-cloog-backend=isl"
    ] ++

    # Java options
    optionals langJava [
      "--with-ecj-jar=${javaEcj}"

      # Follow Sun's layout for the convenience of IcedTea/OpenJDK.  See
      # <http://mail.openjdk.java.net/pipermail/distro-pkg-dev/2010-April/008888.html>.
      "--enable-java-home"
      "--with-java-home=\${prefix}/lib/jvm/jre"
    ] ++
    optional javaAwtGtk "--enable-java-awt=gtk" ++
    optional (langJava && javaAntlr != null) "--with-antlr-jar=${javaAntlr}" ++

    # Ada
    optional langAda "--enable-libada" ++

    platformFlags ++
    optional (targetPlatform != hostPlatform) crossConfigureFlags ++
    optional (!bootstrap) "--disable-bootstrap" ++

    # Platform-specific flags
    optional (targetPlatform == hostPlatform && targetPlatform.isi686) "--with-arch=i686" ++
    optionals hostPlatform.isSunOS [
      "--enable-long-long" "--enable-libssp" "--enable-threads=posix" "--disable-nls" "--enable-__cxa_atexit"
      # On Illumos/Solaris GNU as is preferred
      "--with-gnu-as" "--without-gnu-ld"
    ]
  ;

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = if bootstrap then
    (if profiledCompiler then "profiledbootstrap" else "bootstrap")
    else "";

  installTargets =
    if stripped
    then "install-strip"
    else "install";

  /* For cross-built gcc (build != host == target) */
  crossAttrs =  {
    AR_FOR_BUILD = "ar";
    AS_FOR_BUILD = "as";
    LD_FOR_BUILD = "ld";
    NM_FOR_BUILD = "nm";
    OBJCOPY_FOR_BUILD = "objcopy";
    OBJDUMP_FOR_BUILD = "objdump";
    RANLIB_FOR_BUILD = "ranlib";
    SIZE_FOR_BUILD = "size";
    STRINGS_FOR_BUILD = "strings";
    STRIP_FOR_BUILD = "strip";
    CC_FOR_BUILD = "gcc";
    CXX_FOR_BUILD = "g++";

    AR = "${targetPlatform.config}-ar";
    AS = "${targetPlatform.config}-as";
    LD = "${targetPlatform.config}-ld";
    NM = "${targetPlatform.config}-nm";
    OBJCOPY = "${targetPlatform.config}-objcopy";
    OBJDUMP = "${targetPlatform.config}-objdump";
    RANLIB = "${targetPlatform.config}-ranlib";
    SIZE = "${targetPlatform.config}-size";
    STRINGS = "${targetPlatform.config}-strings";
    STRIP = "${targetPlatform.config}-strip";
    CC = "${targetPlatform.config}-gcc";
    CXX = "${targetPlatform.config}-g++";

    AR_FOR_TARGET = "${targetPlatform.config}-ar";
    AS_FOR_TARGET = "${targetPlatform.config}-as";
    LD_FOR_TARGET = "${targetPlatform.config}-ld";
    NM_FOR_TARGET = "${targetPlatform.config}-nm";
    OBJCOPY_FOR_TARGET = "${targetPlatform.config}-objcopy";
    OBJDUMP_FOR_TARGET = "${targetPlatform.config}-objdump";
    RANLIB_FOR_TARGET = "${targetPlatform.config}-ranlib";
    SIZE_FOR_TARGET = "${targetPlatform.config}-size";
    STRINGS_FOR_TARGET = "${targetPlatform.config}-strings";
    STRIP_FOR_TARGET = "${targetPlatform.config}-strip";
    CC_FOR_TARGET = "${targetPlatform.config}-gcc";
    CXX_FOR_TARGET = "${targetPlatform.config}-g++";

    dontStrip = true;
    buildFlags = "";
  };

  NIX_BUILD_CC = buildPackages.stdenv.cc;

  # Needed for the cross compilation to work
  AR = "ar";
  LD = "ld";
  # http://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  CC = if stdenv.system == "x86_64-solaris" then "gcc -m64" else "gcc";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
  # library headers and binaries, regarless of the language being compiled.
  #
  # Note: When building the Java AWT GTK+ peer, the build system doesn't honor
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
    ++ optional (libpthread != null) libpthread
    ++ optional (libpthreadCross != null) libpthreadCross

    # On GNU/Hurd glibc refers to Mach & Hurd
    # headers.
    ++ optionals (libcCross != null && libcCross ? propagatedBuildInputs)
                 libcCross.propagatedBuildInputs
  ));

  LIBRARY_PATH = optionals (targetPlatform == hostPlatform) (makeLibraryPath ([]
    ++ optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]
    ++ optional (libpthread != null) libpthread)
  );

  EXTRA_TARGET_FLAGS = optionals
    (targetPlatform != hostPlatform && libcCross != null)
    ([
      "-idirafter ${libcCross.dev}/include"
    ] ++ optionals (! crossStageStatic) [
      "-B${libcCross.out}/lib"
    ]);

  EXTRA_TARGET_LDFLAGS = optionals
    (targetPlatform != hostPlatform && libcCross != null)
    ([
      "-Wl,-L${libcCross.out}/lib"
    ] ++ (if crossStageStatic then [
        "-B${libcCross.out}/lib"
      ] else [
        "-Wl,-rpath,${libcCross.out}/lib"
        "-Wl,-rpath-link,${libcCross.out}/lib"
    ]) ++ optionals (libpthreadCross != null) [
      "-L${libpthreadCross}/lib"
      "-Wl,${libpthreadCross.TARGET_LDFLAGS}"
    ]);

  passthru =
    { inherit langC langCC langObjC langObjCpp langAda langFortran langVhdl langGo version; isGNU = true; };

  inherit enableParallelBuilding enableMultilib;

  inherit (stdenv) is64bit;

  meta = {
    homepage = http://gcc.gnu.org/;
    license = stdenv.lib.licenses.gpl3Plus;  # runtime support libraries are typically LGPLv3+
    description = "GNU Compiler Collection, version ${version}"
      + (if stripped then "" else " (with debugging info)");

    longDescription = ''
      The GNU Compiler Collection includes compiler front ends for C, C++,
      Objective-C, Fortran, OpenMP for C/C++/Fortran, Java, and Ada, as well
      as libraries for these languages (libstdc++, libgcj, libgomp,...).

      GCC development is a part of the GNU Project, aiming to improve the
      compiler used in the GNU system including the GNU/Linux variant.
    '';

    maintainers = with stdenv.lib.maintainers; [ viric peti ];

    # gnatboot is not available out of linux platforms, so we disable the darwin build
    # for the gnat (ada compiler).
    platforms =
      stdenv.lib.platforms.linux ++
      stdenv.lib.platforms.freebsd ++
      stdenv.lib.platforms.illumos ++
      optionals (langAda == false) stdenv.lib.platforms.darwin;
  };
}

// optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

# Strip kills static libs of other archs (hence targetPlatform != hostPlatform)
// optionalAttrs (!stripped || targetPlatform != hostPlatform) { dontStrip = true; }

// optionalAttrs (enableMultilib) { dontMoveLib64 = true; }
)
