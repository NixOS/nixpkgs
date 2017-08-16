{ stdenv, fetchurl, noSysDirs
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
, isl ? null # optional, for the Graphite optimization framework.
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkgconfig ? null
, gtk2 ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xproto ? null, renderproto ? null, xextproto ? null
, libXrandr ? null, libXi ? null, inputproto ? null, randrproto ? null
, x11Support ? langJava
, gnatboot ? null
, enableMultilib ? false
, enablePlugin ? true             # whether to support user-supplied plug-ins
, name ? "gcc"
, libcCross ? null
, crossStageStatic ? true
, gnat ? null
, libpthread ? null, libpthreadCross ? null  # required for GNU/Hurd
, stripped ? true
, gnused ? null
, binutils ? null
, cloog # unused; just for compat with gcc4, as we override the parameter on some places
, darwin ? null
, buildPlatform, hostPlatform, targetPlatform
}:

assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null
                       && perl != null;  # for `--enable-java-home'
assert langAda      -> gnatboot != null;
assert langVhdl     -> gnat != null;

# LTO needs libelf and zlib.
assert libelf != null -> zlib != null;

# Make sure we get GNU sed.
assert hostPlatform.isDarwin -> gnused != null;

# Need c++filt on darwin
assert hostPlatform.isDarwin -> binutils != null;

# The go frontend is written in c++
assert langGo -> langCC;

with stdenv.lib;
with builtins;

let version = "6.4.0";

    # Whether building a cross-compiler for GNU/Hurd.
    crossGNU = targetPlatform != hostPlatform && targetPlatform.config == "i586-pc-gnu";

    enableParallelBuilding = true;

    patches =
      [ ../use-source-date-epoch.patch ]
      ++ optional (targetPlatform != hostPlatform) ../libstdc++-target.patch
      ++ optional noSysDirs ../no-sys-dirs.patch
      # The GNAT Makefiles did not pay attention to CFLAGS_FOR_TARGET for its
      # target libraries and tools.
      ++ optional langAda ../gnat-cflags.patch
      ++ optional langFortran ../gfortran-driving.patch;

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
        gccArch = stdenv.platform.gcc.arch or null;
        gccCpu = stdenv.platform.gcc.cpu or null;
        gccAbi = stdenv.platform.gcc.abi or null;
        gccFpu = stdenv.platform.gcc.fpu or null;
        gccFloat = stdenv.platform.gcc.float or null;
        gccMode = stdenv.platform.gcc.mode or null;
        withArch = if gccArch != null then " --with-arch=${gccArch}" else "";
        withCpu = if gccCpu != null then " --with-cpu=${gccCpu}" else "";
        withAbi = if gccAbi != null then " --with-abi=${gccAbi}" else "";
        withFpu = if gccFpu != null then " --with-fpu=${gccFpu}" else "";
        withFloat = if gccFloat != null then " --with-float=${gccFloat}" else "";
        withMode = if gccMode != null then " --with-mode=${gccMode}" else "";
      in
        withArch +
        withCpu +
        withAbi +
        withFpu +
        withFloat +
        withMode;

    /* Cross-gcc settings */
    crossMingw = targetPlatform != hostPlatform && targetPlatform.libc == "msvcrt";
    crossDarwin = targetPlatform != hostPlatform && targetPlatform.libc == "libSystem";
    crossConfigureFlags = let
        gccArch = targetPlatform.gcc.arch or null;
        gccCpu = targetPlatform.gcc.cpu or null;
        gccAbi = targetPlatform.gcc.abi or null;
        gccFpu = targetPlatform.gcc.fpu or null;
        gccFloat = targetPlatform.gcc.float or null;
        gccMode = targetPlatform.gcc.mode or null;
        withArch = if gccArch != null then " --with-arch=${gccArch}" else "";
        withCpu = if gccCpu != null then " --with-cpu=${gccCpu}" else "";
        withAbi = if gccAbi != null then " --with-abi=${gccAbi}" else "";
        withFpu = if gccFpu != null then " --with-fpu=${gccFpu}" else "";
        withFloat = if gccFloat != null then " --with-float=${gccFloat}" else "";
        withMode = if gccMode != null then " --with-mode=${gccMode}" else "";
      in
        "--target=${targetPlatform.config}" +
        withArch +
        withCpu +
        withAbi +
        withFpu +
        withFloat +
        withMode +
        # Ensure that -print-prog-name is able to find the correct programs.
        " --with-as=${binutils}/bin/${targetPlatform.config}-as" +
        " --with-ld=${binutils}/bin/${targetPlatform.config}-ld" +
        (if crossMingw && crossStageStatic then
          " --with-headers=${libcCross}/include" +
          " --with-gcc" +
          " --with-gnu-as" +
          " --with-gnu-ld" +
          " --with-gnu-ld" +
          " --disable-shared" +
          " --disable-nls" +
          " --disable-debug" +
          " --enable-sjlj-exceptions" +
          " --enable-threads=win32" +
          " --disable-win32-registry"
          else if crossStageStatic then
          " --disable-libssp --disable-nls" +
          " --without-headers" +
          " --disable-threads " +
          " --disable-libgomp " +
          " --disable-libquadmath" +
          " --disable-shared" +
          " --disable-libatomic " +  # libatomic requires libc
          " --disable-decimal-float" # libdecnumber requires libc
          else
          (if crossDarwin then " --with-sysroot=${getLib libcCross}/share/sysroot"
           else                " --with-headers=${getDev libcCross}/include") +
          " --enable-__cxa_atexit" +
          " --enable-long-long" +
          (if crossMingw then
            " --enable-threads=win32" +
            " --enable-sjlj-exceptions" +
            " --enable-hash-synchronization" +
            " --disable-libssp" +
            " --disable-nls" +
            " --with-dwarf2" +
            # I think noone uses shared gcc libs in mingw, so we better do the same.
            # In any case, mingw32 g++ linking is broken by default with shared libs,
            # unless adding "-lsupc++" to any linking command. I don't know why.
            " --disable-shared" +
            # To keep ABI compatibility with upstream mingw-w64
            " --enable-fully-dynamic-string"
            else (if targetPlatform.libc == "uclibc" then
              # libsanitizer requires netrom/netrom.h which is not
              # available in uclibc.
              " --disable-libsanitizer" +
              # In uclibc cases, libgomp needs an additional '-ldl'
              # and as I don't know how to pass it, I disable libgomp.
              " --disable-libgomp" else "") +
            " --enable-threads=posix" +
            " --enable-nls" +
            " --disable-decimal-float") # No final libdecnumber (it may work only in 386)
          );
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
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "1m0lr7938lw5d773dkvwld90hjlcq2282517d1gwvrfzmwgg42w5";
  };

  inherit patches;

  outputs = [ "out" "lib" "man" "info" ];
  setOutputFlags = false;
  NIX_NO_SELF_RPATH = true;

  libc_dev = stdenv.cc.libc_dev;

  hardeningDisable = [ "format" ];

  # This should kill all the stdinc frameworks that gcc and friends like to
  # insert into default search paths.
  prePatch = stdenv.lib.optionalString hostPlatform.isDarwin ''
    substituteInPlace gcc/config/darwin-c.c \
      --replace 'if (stdinc)' 'if (0)'

    substituteInPlace libgcc/config/t-slibgcc-darwin \
      --replace "-install_name @shlib_slibdir@/\$(SHLIB_INSTALL_NAME)" "-install_name $lib/lib/\$(SHLIB_INSTALL_NAME)"

    substituteInPlace libgfortran/configure \
      --replace "-install_name \\\$rpath/\\\$soname" "-install_name $lib/lib/\\\$soname"
  '';

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

  inherit noSysDirs staticCompiler langJava crossStageStatic
    libcCross crossMingw;

  nativeBuildInputs = [ texinfo which gettext ]
    ++ (optional (perl != null) perl)
    ++ (optional javaAwtGtk pkgconfig);

  buildInputs = [ gmp mpfr libmpc libelf ]
    ++ (optional (isl != null) isl)
    ++ (optional (zlib != null) zlib)
    ++ (optionals langJava [ boehmgc zip unzip ])
    ++ (optionals javaAwtGtk ([ gtk2 libart_lgpl ] ++ xlibs))
    ++ (optionals (targetPlatform != hostPlatform) [binutils])
    ++ (optionals langAda [gnatboot])
    ++ (optionals langVhdl [gnat])

    # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
    # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
    ++ (optional hostPlatform.isDarwin gnused)
    ++ (optional hostPlatform.isDarwin binutils)
    ;

  NIX_LDFLAGS = stdenv.lib.optionalString  hostPlatform.isSunOS "-lm -ldl";

  preConfigure = stdenv.lib.optionalString (hostPlatform.isSunOS && hostPlatform.is64bit) ''
    export NIX_LDFLAGS=`echo $NIX_LDFLAGS | sed -e s~$prefix/lib~$prefix/lib/amd64~g`
    export LDFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $LDFLAGS_FOR_TARGET"
    export CXXFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CXXFLAGS_FOR_TARGET"
    export CFLAGS_FOR_TARGET="-Wl,-rpath,$prefix/lib/amd64 $CFLAGS_FOR_TARGET"
  '';

  dontDisableStatic = true;

  configureFlags = "
    ${if hostPlatform.isSunOS then
      " --enable-long-long --enable-libssp --enable-threads=posix --disable-nls --enable-__cxa_atexit " +
      # On Illumos/Solaris GNU as is preferred
      " --with-gnu-as --without-gnu-ld "
      else ""}
    --enable-lto
    ${if enableMultilib then "--enable-multilib --disable-libquadmath" else "--disable-multilib"}
    ${if enableShared then "" else "--disable-shared"}
    ${if enablePlugin then "--enable-plugin" else "--disable-plugin"}
    ${optionalString (isl != null) "--with-isl=${isl}"}
    ${if langJava then
      "--with-ecj-jar=${javaEcj} " +

      # Follow Sun's layout for the convenience of IcedTea/OpenJDK.  See
      # <http://mail.openjdk.java.net/pipermail/distro-pkg-dev/2010-April/008888.html>.
      "--enable-java-home --with-java-home=\${prefix}/lib/jvm/jre "
      else ""}
    ${if javaAwtGtk then "--enable-java-awt=gtk" else ""}
    ${if langJava && javaAntlr != null then "--with-antlr-jar=${javaAntlr}" else ""}
    --with-gmp-include=${gmp.dev}/include
    --with-gmp-lib=${gmp.out}/lib
    --with-mpfr-include=${mpfr.dev}/include
    --with-mpfr-lib=${mpfr.out}/lib
    --with-mpc=${libmpc}
    ${if libelf != null then "--with-libelf=${libelf}" else ""}
    --disable-libstdcxx-pch
    --without-included-gettext
    --with-system-zlib
    --enable-static
    --enable-languages=${
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
    }
    ${if targetPlatform == hostPlatform
      then if hostPlatform.isDarwin
        then " --with-native-system-header-dir=${darwin.usr-include}"
        else " --with-native-system-header-dir=${getDev stdenv.cc.libc}/include"
      else ""}
    ${if langAda then " --enable-libada" else ""}
    ${if targetPlatform == hostPlatform && targetPlatform.isi686 then "--with-arch=i686" else ""}
    ${if targetPlatform != hostPlatform then crossConfigureFlags else ""}
    ${if !bootstrap then "--disable-bootstrap" else ""}
    ${if targetPlatform == hostPlatform then platformFlags else ""}
  ";

  targetConfig = if targetPlatform != hostPlatform then targetPlatform.config else null;

  buildFlags = if bootstrap then
    (if profiledCompiler then "profiledbootstrap" else "bootstrap")
    else "";

  installTargets =
    if stripped
    then "install-strip"
    else "install";

  crossAttrs = let
    xgccArch = targetPlatform.gcc.arch or null;
    xgccCpu = targetPlatform.gcc.cpu or null;
    xgccAbi = targetPlatform.gcc.abi or null;
    xgccFpu = targetPlatform.gcc.fpu or null;
    xgccFloat = targetPlatform.gcc.float or null;
    xwithArch = if xgccArch != null then " --with-arch=${xgccArch}" else "";
    xwithCpu = if xgccCpu != null then " --with-cpu=${xgccCpu}" else "";
    xwithAbi = if xgccAbi != null then " --with-abi=${xgccAbi}" else "";
    xwithFpu = if xgccFpu != null then " --with-fpu=${xgccFpu}" else "";
    xwithFloat = if xgccFloat != null then " --with-float=${xgccFloat}" else "";
  in {
    AR = "${targetPlatform.config}-ar";
    LD = "${targetPlatform.config}-ld";
    CC = "${targetPlatform.config}-gcc";
    CXX = "${targetPlatform.config}-gcc";
    AR_FOR_TARGET = "${targetPlatform.config}-ar";
    LD_FOR_TARGET = "${targetPlatform.config}-ld";
    CC_FOR_TARGET = "${targetPlatform.config}-gcc";
    NM_FOR_TARGET = "${targetPlatform.config}-nm";
    CXX_FOR_TARGET = "${targetPlatform.config}-g++";
    # If we are making a cross compiler, cross != null
    NIX_CC_CROSS = optionalString (targetPlatform == hostPlatform) builtins.toString stdenv.cc;
    dontStrip = true;
    configureFlags = ''
      ${if enableMultilib then "" else "--disable-multilib"}
      ${if enableShared then "" else "--disable-shared"}
      ${if langJava then "--with-ecj-jar=${javaEcj.crossDrv}" else ""}
      ${if javaAwtGtk then "--enable-java-awt=gtk" else ""}
      ${if langJava && javaAntlr != null then "--with-antlr-jar=${javaAntlr.crossDrv}" else ""}
      --with-gmp=${gmp.crossDrv}
      --with-mpfr=${mpfr.crossDrv}
      --with-mpc=${libmpc.crossDrv}
      --disable-libstdcxx-pch
      --without-included-gettext
      --with-system-zlib
      --enable-languages=${
        concatStrings (intersperse ","
          (  optional langC        "c"
          ++ optional langCC       "c++"
          ++ optional langFortran  "fortran"
          ++ optional langJava     "java"
          ++ optional langAda      "ada"
          ++ optional langVhdl     "vhdl"
          ++ optional langGo       "go"
          )
        )
      }
      ${if langAda then " --enable-libada" else ""}
      --target=${targetPlatform.config}
      ${xwithArch}
      ${xwithCpu}
      ${xwithAbi}
      ${xwithFpu}
      ${xwithFloat}
    '';
    buildFlags = "";
  };


  # Needed for the cross compilation to work
  AR = "ar";
  LD = "ld";
  # http://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
  CC = if stdenv.system == "x86_64-solaris" then "gcc -m64" else "gcc";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find
  # the library headers and binaries, regarless of the language being
  # compiled.

  # Note: When building the Java AWT GTK+ peer, the build system doesn't
  # honor `--with-gmp' et al., e.g., when building
  # `libjava/classpath/native/jni/java-math/gnu_java_math_GMP.c', so we just
  # add them to $CPATH and $LIBRARY_PATH in this case.
  #
  # Likewise, the LTO code doesn't find zlib.

  CPATH = makeSearchPathOutput "dev" "include" ([]
    ++ optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]
    ++ optional (libpthread != null) libpthread
    ++ optional (libpthreadCross != null) libpthreadCross

    # On GNU/Hurd glibc refers to Mach & Hurd
    # headers.
    ++ optionals (libcCross != null && libcCross ? "propagatedBuildInputs")
                 libcCross.propagatedBuildInputs);

  LIBRARY_PATH = makeLibraryPath ([]
    ++ optional (zlib != null) zlib
    ++ optional langJava boehmgc
    ++ optionals javaAwtGtk xlibs
    ++ optionals javaAwtGtk [ gmp mpfr ]
    ++ optional (libpthread != null) libpthread);

  EXTRA_TARGET_CFLAGS =
    if targetPlatform != hostPlatform && libcCross != null then [
        "-idirafter ${getDev libcCross}/include"
      ]
      ++ optionals (! crossStageStatic) [
        "-B${libcCross.out}/lib"
      ]
    else null;

  EXTRA_TARGET_LDFLAGS =
    if targetPlatform != hostPlatform && libcCross != null then [
        "-Wl,-L${libcCross.out}/lib"
      ]
      ++ (if crossStageStatic then [
        "-B${libcCross.out}/lib"
      ] else [
        "-Wl,-rpath,${libcCross.out}/lib"
        "-Wl,-rpath-link,${libcCross.out}/lib"
      ])
      ++ optionals (libpthreadCross != null) [
        "-L${libpthreadCross}/lib"
        "-Wl,${libpthreadCross.TARGET_LDFLAGS}"
      ]
    else null;

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
