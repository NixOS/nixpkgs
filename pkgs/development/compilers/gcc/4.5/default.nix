{ stdenv, targetPackages, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, langJava ? false
, langAda ? false
, langVhdl ? false
, profiledCompiler ? false
, staticCompiler ? false
, enableShared ? true
, texinfo ? null
, perl ? null # optional, for texi2pod (then pod2man); required for Java
, gmp, mpfr, libmpc, gettext, which
, libelf                      # optional, for link-time optimizations (LTO)
, ppl ? null, cloogppl ? null # optional, for the Graphite optimization framework
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkgconfig ? null, gtk2 ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xproto ? null, renderproto ? null, xextproto ? null
, libXrandr ? null, libXi ? null, inputproto ? null, randrproto ? null
, gnatboot ? null
, enableMultilib ? false
, name ? "gcc"
, libcCross ? null
, crossStageStatic ? false
, gnat ? null
, libpthread ? null, libpthreadCross ? null  # required for GNU/Hurd
, stripped ? true
, buildPlatform, hostPlatform, targetPlatform
, buildPackages
}:

assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null
                       && perl != null;  # for `--enable-java-home'
assert langAda      -> gnatboot != null;
assert langVhdl     -> gnat != null;

# LTO needs libelf and zlib.
assert libelf != null -> zlib != null;

with stdenv.lib;
with builtins;

let version = "4.5.4";
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
      url = http://www.antlr.org/download/antlr-3.1.3.jar;
      sha256 = "1f41j0y4kjydl71lqlvr73yagrs2jsg1fjymzjz66mjy7al5lh09";
    };

    xlibs = [
      libX11 libXt libSM libICE libXtst libXrender libXrandr libXi
      xproto renderproto xextproto inputproto randrproto
    ];

    javaAwtGtk = langJava && gtk2 != null;

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

    /* Cross-gcc settings */
    crossMingw = (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt");

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
        "--disable-libmudflap"
        "--disable-libgomp"
        "--disable-shared"
        "--disable-decimal-float" # libdecnumber requires libc
      ] else [
        "--with-headers=${libcCross}/include"
        "--enable-__cxa_atexit"
        "--enable-long-long"
      ] ++
        (if crossMingw then [
          "--enable-threads=win32"
          "--enable-sjlj-exceptions"
          "--enable-hash-synchronization"
          "--enable-version-specific-runtime-libs"
          "--enable-libssp"
          "--disable-nls"
          "--with-dwarf2"
        ] else [
          "--enable-threads=posix"
          "--enable-nls"
          "--disable-decimal-float" # No final libdecnumber (it may work only in 386)
        ]));
    stageNameAddon = if crossStageStatic then "-stage-static" else
      "-stage-final";
    crossNameAddon = if targetPlatform != hostPlatform then "-${targetPlatform.config}" + stageNameAddon else "";

in

# We need all these X libraries when building AWT with GTK+.
assert gtk2 != null -> (filter (x: x == null) xlibs) == [];

stdenv.mkDerivation ({
  name = "${name}-${version}" + crossNameAddon;

  builder = ../builder.sh;

  src = (import ./sources.nix) {
    inherit fetchurl optional version;
    inherit langC langCC langFortran langJava langAda;
  };

  hardeningDisable = [ "format" ] ++ optional (name != "gnat") "all";

  outputs = [ "out" "man" "info" ]
    ++ optional (!(hostPlatform.is64bit && langAda)) "lib";

  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  patches =
    [ ]
    ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
    ++ optional noSysDirs ./no-sys-dirs.patch
    # The GNAT Makefiles did not pay attention to CFLAGS_FOR_TARGET for its
    # target libraries and tools.
    ++ optional langAda ../gnat-cflags.patch
    ++ optional langVhdl ./ghdl-ortho-cflags.patch
    ++ [ ../struct-ucontext-4.5.patch ] # glibc-2.26
    ;

  postPatch =
    if (stdenv.system == "i586-pc-gnu"
        || (libcCross != null                  # e.g., building `gcc.crossDrv'
            && libcCross ? crossConfig
            && libcCross.crossConfig == "i586-pc-gnu")
        || (targetPlatform != hostPlatform && targetPlatform.config == "i586-pc-gnu"
            && libcCross != null))
    then
      # On GNU/Hurd glibc refers to Hurd & Mach headers and libpthread is not
      # in glibc, so add the right `-I' flags to the default spec string.
      assert libcCross != null -> libpthreadCross != null;
      let
        libc = if libcCross != null then libcCross else stdenv.glibc;
        gnu_h = "gcc/config/gnu.h";
        i386_gnu_h = "gcc/config/i386/gnu.h";
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
        '' echo "augmenting \`CPP_SPEC' in \`${i386_gnu_h}' with \`${extraCPPSpec}'..."
           sed -i "${i386_gnu_h}" \
               -es'|CPP_SPEC *"\(.*\)$|CPP_SPEC "${extraCPPSpec} \1|g'

           echo "augmenting \`LIB_SPEC' in \`${gnu_h}' with \`${extraLibSpec}'..."
           sed -i "${gnu_h}" \
               -es'|LIB_SPEC *"\(.*\)$|LIB_SPEC "${extraLibSpec} \1|g'

           echo "setting \`NATIVE_SYSTEM_HEADER_DIR' and \`STANDARD_INCLUDE_DIR' to \`${libc.dev}/include'..."
           sed -i "${gnu_h}" \
               -es'|#define STANDARD_INCLUDE_DIR.*$|#define STANDARD_INCLUDE_DIR "${libc.dev}/include"|g'
           sed -i gcc/config/t-gnu \
               -es'|NATIVE_SYSTEM_HEADER_DIR.*$|NATIVE_SYSTEM_HEADER_DIR = ${libc.dev}/include|g'
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
  inherit noSysDirs profiledCompiler staticCompiler langJava
    libcCross crossMingw;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ texinfo which gettext ]
    ++ optional (perl != null) perl;

  # For building runtime libs
  depsBuildTarget =
    if hostPlatform == buildPlatform then [
      targetPackages.stdenv.cc.bintools # newly-built gcc will be used
    ] else assert targetPlatform == hostPlatform; [ # build != host == target
      stdenv.cc
    ];

  buildInputs = [
    gmp mpfr libmpc libelf
    targetPackages.stdenv.cc.bintools # For linking code at run-time
  ] ++ (optional (ppl != null) ppl)
    ++ (optional (cloogppl != null) cloogppl)
    ++ (optional (zlib != null) zlib)
    ++ (optional langJava boehmgc)
    ++ (optionals langJava [zip unzip])
    ++ (optionals javaAwtGtk ([gtk2 pkgconfig libart_lgpl] ++ xlibs))
    ++ (optionals (targetPlatform != hostPlatform) [targetPackages.stdenv.cc.bintools])
    ++ (optionals langAda [gnatboot])
    ++ (optionals langVhdl [gnat])
    ;

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms =
    # TODO(@Ericson2314): Figure out what's going wrong with Arm
    if buildPlatform == hostPlatform && hostPlatform == targetPlatform && targetPlatform.isArm
    then []
    else [ "build" "host" ] ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";

  configureFlags =
    # Basic dependencies
    [
      "--with-gmp=${gmp.dev}"
      "--with-mpfr=${mpfr.dev}"
      "--with-mpc=${libmpc}"
    ] ++
    optional (libelf != null) "--with-libelf=${libelf}" ++
    optional (!(crossMingw && crossStageStatic))
      "--with-native-system-header-dir=${getDev stdenv.cc.libc}/include" ++

    # Basic configuration
    [
      "--disable-libstdcxx-pch"
      "--without-included-gettext"
      "--with-system-zlib"
      "--enable-languages=${
        concatStrings (intersperse ","
          (  optional langC        "c"
          ++ optional langCC       "c++"
          ++ optional langFortran  "fortran"
          ++ optional langJava     "java"
          ++ optional langAda      "ada"
          ++ optional langVhdl     "vhdl"
          )
        )
      }"
    ] ++
    optional (!enableMultilib) "--disable-multilib" ++
    optional (!enableShared) "--disable-shared" ++

    # Optional features
    optional (cloogppl != null) "--with-cloog=${cloogppl}" ++
    optional (ppl != null) "--with-ppl=${ppl}" ++

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

    # Platform-specific flags
    optional (targetPlatform == hostPlatform && targetPlatform.isi686) "--with-arch=i686" ++
    # Trick that should be taken out once we have a mipsel-linux not loongson2f
    optional (targetPlatform == hostPlatform && stdenv.system == "mipsel-linux") "--with-arch=loongson2f"
  ;

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  /* For cross-built gcc (build != host == target) */
  crossAttrs = {
    dontStrip = true;
  };

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

  passthru = {
    inherit langC langCC langAda langFortran langVhdl enableMultilib version;
    isGNU = true;
    hardeningUnsupportedFlags = [ "stackprotector" ];
  };

  enableParallelBuilding = !langAda;

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

    maintainers = [
      stdenv.lib.maintainers.viric
    ];

    # Volunteers needed for the {Cyg,Dar}win ports of *PPL.
    # gnatboot is not available out of linux platforms, so we disable the darwin build
    # for the gnat (ada compiler).
    platforms = stdenv.lib.platforms.linux ++ optionals (langAda == false) [ "i686-darwin" ];
  };
}

// optionalAttrs (targetPlatform != hostPlatform || libcCross != null) {
  # `builder.sh' sets $CPP, which leads configure to use "gcc -E" instead of,
  # say, "i586-pc-gnu-gcc -E" when building `gcc.crossDrv'.
  # FIXME: Fix `builder.sh' directly in the next stdenv-update.
  postUnpack = "unset CPP";
}

// optionalAttrs (targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt" && crossStageStatic) {
  makeFlags = [ "all-gcc" "all-target-libgcc" ];
  installTargets = "install-gcc install-target-libgcc";
}

# GCC 4.5.2 doesn't support the `install-strip' target, so let `stdenv' do
# the stripping by default.
// optionalAttrs (!stripped) { dontStrip = true; }

// optionalAttrs langVhdl rec {
  name = "ghdl-0.29";

  ghdlSrc = fetchurl {
    url = "http://ghdl.free.fr/ghdl-0.29.tar.bz2";
    sha256 = "15mlinr1lwljwll9ampzcfcrk9bk0qpdks1kxlvb70xf9zhh2jva";
  };

  # Ghdl has some timestamps checks, storing file timestamps in '.cf' files.
  # As we will change the timestamps to 1970-01-01 00:00:01, we also set the
  # content of that .cf to that value. This way ghdl does not complain on
  # the installed object files from the basic libraries (ieee, ...)
  postInstallGhdl = ''
    pushd $out
    find . -name "*.cf" -exec \
        sed 's/[0-9]*\.000" /19700101000001.000" /g' -i {} \;
    popd
  '';

  postUnpack = ''
    tar xvf ${ghdlSrc}
    mv ghdl-*/vhdl gcc*/gcc
    rm -Rf ghdl-*
  '';

  meta = {
    homepage = http://ghdl.free.fr/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Complete VHDL simulator, using the GCC technology (gcc ${version})";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

})
