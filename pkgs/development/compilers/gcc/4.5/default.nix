{ stdenv, fetchurl, noSysDirs
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
, zip ? null, unzip ? null, pkgconfig ? null, gtk ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, libXrender ? null, xproto ? null, renderproto ? null, xextproto ? null
, libXrandr ? null, libXi ? null, inputproto ? null, randrproto ? null
, gnatboot ? null
, enableMultilib ? false
, name ? "gcc"
, cross ? null
, binutilsCross ? null
, libcCross ? null
, crossStageStatic ? true
, gnat ? null
, libpthread ? null, libpthreadCross ? null  # required for GNU/Hurd
, stripped ? true
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

    javaAwtGtk = langJava && gtk != null;

    /* Cross-gcc settings */
    gccArch = stdenv.lib.attrByPath [ "gcc" "arch" ] null cross;
    gccCpu = stdenv.lib.attrByPath [ "gcc" "cpu" ] null cross;
    gccAbi = stdenv.lib.attrByPath [ "gcc" "abi" ] null cross;
    withArch = if gccArch != null then " --with-arch=${gccArch}" else "";
    withCpu = if gccCpu != null then " --with-cpu=${gccCpu}" else "";
    withAbi = if gccAbi != null then " --with-abi=${gccAbi}" else "";
    crossMingw = (cross != null && cross.libc == "msvcrt");

    crossConfigureFlags =
      "--target=${cross.config}" +
      withArch +
      withCpu +
      withAbi +
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
        " --disable-libmudflap " +
        " --disable-libgomp " +
        " --disable-shared" +
        " --disable-decimal-float" # libdecnumber requires libc
        else
        " --with-headers=${libcCross}/include" +
        " --enable-__cxa_atexit" +
        " --enable-long-long" +
        (if crossMingw then
          " --enable-threads=win32" +
          " --enable-sjlj-exceptions" +
          " --enable-hash-synchronization" +
          " --enable-version-specific-runtime-libs" +
          " --disable-libssp" +
          " --disable-nls" +
          " --with-dwarf2"
          else
          " --enable-threads=posix" +
          " --enable-nls" +
          " --disable-decimal-float") # No final libdecnumber (it may work only in 386)
        );
    stageNameAddon = if crossStageStatic then "-stage-static" else
      "-stage-final";
    crossNameAddon = if cross != null then "-${cross.config}" + stageNameAddon else "";

in

# We need all these X libraries when building AWT with GTK+.
assert gtk != null -> (filter (x: x == null) xlibs) == [];

stdenv.mkDerivation ({
  name = "${name}-${version}" + crossNameAddon;

  builder = ./builder.sh;

  src = (import ./sources.nix) {
    inherit fetchurl optional version;
    inherit langC langCC langFortran langJava langAda;
  };

  patches =
    [ ]
    ++ optional (cross != null) ../libstdc++-target.patch
    ++ optional noSysDirs ./no-sys-dirs.patch
    # The GNAT Makefiles did not pay attention to CFLAGS_FOR_TARGET for its
    # target libraries and tools.
    ++ optional langAda ../gnat-cflags.patch
    ++ optional langVhdl ./ghdl-ortho-cflags.patch
    ;

  postPatch =
    if (stdenv.system == "i586-pc-gnu"
        || (libcCross != null                  # e.g., building `gcc.crossDrv'
            && libcCross ? crossConfig
            && libcCross.crossConfig == "i586-pc-gnu")
        || (cross != null && cross.config == "i586-pc-gnu"
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
                          (map (x: "-I${x}/include") extraCPPDeps));
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

           echo "setting \`NATIVE_SYSTEM_HEADER_DIR' and \`STANDARD_INCLUDE_DIR' to \`${libc}/include'..."
           sed -i "${gnu_h}" \
               -es'|#define STANDARD_INCLUDE_DIR.*$|#define STANDARD_INCLUDE_DIR "${libc}/include"|g'
           sed -i gcc/config/t-gnu \
               -es'|NATIVE_SYSTEM_HEADER_DIR.*$|NATIVE_SYSTEM_HEADER_DIR = ${libc}/include|g'
        ''
    else if cross != null || stdenv.cc.libc != null then
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
                 -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc}\3"|g'
           done
        ''
    else null;

  inherit noSysDirs profiledCompiler staticCompiler langJava crossStageStatic
    libcCross crossMingw;

  nativeBuildInputs = [ texinfo which ]
    ++ optional (perl != null) perl;
    
  buildInputs = [ gmp mpfr libmpc libelf gettext ]
    ++ (optional (ppl != null) ppl)
    ++ (optional (cloogppl != null) cloogppl)
    ++ (optional (zlib != null) zlib)
    ++ (optional langJava boehmgc)
    ++ (optionals langJava [zip unzip])
    ++ (optionals javaAwtGtk ([gtk pkgconfig libart_lgpl] ++ xlibs))
    ++ (optionals (cross != null) [binutilsCross])
    ++ (optionals langAda [gnatboot])
    ++ (optionals langVhdl [gnat])
    ;

  configureFlags = "
    ${if enableMultilib then "" else "--disable-multilib"}
    ${if enableShared then "" else "--disable-shared"}
    ${if ppl != null then "--with-ppl=${ppl}" else ""}
    ${if cloogppl != null then "--with-cloog=${cloogppl}" else ""}
    ${if langJava then
      "--with-ecj-jar=${javaEcj} " +

      # Follow Sun's layout for the convenience of IcedTea/OpenJDK.  See
      # <http://mail.openjdk.java.net/pipermail/distro-pkg-dev/2010-April/008888.html>.
      "--enable-java-home --with-java-home=\${prefix}/lib/jvm/jre "
      else ""}
    ${if javaAwtGtk then "--enable-java-awt=gtk" else ""}
    ${if langJava && javaAntlr != null then "--with-antlr-jar=${javaAntlr}" else ""}
    --with-gmp=${gmp.dev}
    --with-mpfr=${mpfr.dev}
    --with-mpc=${libmpc}
    ${if libelf != null then "--with-libelf=${libelf}" else ""}
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
        )
      )
    }
    ${ # Trick that should be taken out once we have a mips64el-linux not loongson2f
      if cross == null && stdenv.system == "mips64el-linux" then "--with-arch=loongson2f" else ""}
    ${if langAda then " --enable-libada" else ""}
    ${if cross == null && stdenv.isi686 then "--with-arch=i686" else ""}
    ${if cross != null then crossConfigureFlags else ""}
  ";

  targetConfig = if cross != null then cross.config else null;

  crossAttrs = {
    AR = "${stdenv.cross.config}-ar";
    LD = "${stdenv.cross.config}-ld";
    CC = "${stdenv.cross.config}-gcc";
    CXX = "${stdenv.cross.config}-gcc";
    AR_FOR_TARGET = "${stdenv.cross.config}-ar";
    LD_FOR_TARGET = "${stdenv.cross.config}-ld";
    CC_FOR_TARGET = "${stdenv.cross.config}-gcc";
    NM_FOR_TARGET = "${stdenv.cross.config}-nm";
    CXX_FOR_TARGET = "${stdenv.cross.config}-g++";
    # If we are making a cross compiler, cross != null
    NIX_CC_CROSS = if cross == null then "${stdenv.ccCross}" else "";
    dontStrip = true;
    configureFlags = ''
      ${if enableMultilib then "" else "--disable-multilib"}
      ${if enableShared then "" else "--disable-shared"}
      ${if ppl != null then "--with-ppl=${ppl.crossDrv}" else ""}
      ${if cloogppl != null then "--with-cloog=${cloogppl.crossDrv}" else ""}
      ${if langJava then "--with-ecj-jar=${javaEcj.crossDrv}" else ""}
      ${if javaAwtGtk then "--enable-java-awt=gtk" else ""}
      ${if langJava && javaAntlr != null then "--with-antlr-jar=${javaAntlr.crossDrv}" else ""}
      --with-gmp=${gmp.crossDrv}
      --with-mpfr=${mpfr.crossDrv}
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
          )
        )
      }
      ${if langAda then " --enable-libada" else ""}
      ${if cross == null && stdenv.isi686 then "--with-arch=i686" else ""}
      ${if cross != null then crossConfigureFlags else ""}
      --target=${stdenv.cross.config}
    '';
  };
 

  # Needed for the cross compilation to work
  AR = "ar";
  LD = "ld";
  CC = "gcc";

  # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find
  # the library headers and binaries, regarless of the language being
  # compiled.

  # Note: When building the Java AWT GTK+ peer, the build system doesn't
  # honor `--with-gmp' et al., e.g., when building
  # `libjava/classpath/native/jni/java-math/gnu_java_math_GMP.c', so we just
  # add them to $CPATH and $LIBRARY_PATH in this case.
  #
  # Likewise, the LTO code doesn't find zlib.

  CPATH = concatStrings
            (intersperse ":" (map (x: x + "/include")
                                  (optionals (zlib != null) [ zlib ]
                                   ++ optionals langJava [ boehmgc ]
                                   ++ optionals javaAwtGtk xlibs
                                   ++ optionals javaAwtGtk [ gmp mpfr ]
                                   ++ optional (libpthread != null) libpthread
                                   ++ optional (libpthreadCross != null) libpthreadCross

                                   # On GNU/Hurd glibc refers to Mach & Hurd
                                   # headers.
                                   ++ optionals (libcCross != null &&
                                                 hasAttr "propagatedBuildInputs" libcCross)
                                        libcCross.propagatedBuildInputs)));

  LIBRARY_PATH = concatStrings
                   (intersperse ":" (map (x: x + "/lib")
                                         (optionals (zlib != null) [ zlib ]
                                          ++ optionals langJava [ boehmgc ]
                                          ++ optionals javaAwtGtk xlibs
                                          ++ optionals javaAwtGtk [ gmp mpfr ]
                                          ++ optional (libpthread != null) libpthread)));

  EXTRA_TARGET_CFLAGS =
    if cross != null && libcCross != null
    then "-idirafter ${libcCross}/include"
    else null;

  EXTRA_TARGET_LDFLAGS =
    if cross != null && libcCross != null
    then "-B${libcCross}/lib -Wl,-L${libcCross}/lib" +
         (optionalString (libpthreadCross != null)
           " -L${libpthreadCross}/lib -Wl,${libpthreadCross.TARGET_LDFLAGS}")
    else null;

  passthru = { inherit langC langCC langAda langFortran langVhdl
      enableMultilib version; isGNU = true; };

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

// optionalAttrs (cross != null || libcCross != null) {
  # `builder.sh' sets $CPP, which leads configure to use "gcc -E" instead of,
  # say, "i586-pc-gnu-gcc -E" when building `gcc.crossDrv'.
  # FIXME: Fix `builder.sh' directly in the next stdenv-update.
  postUnpack = "unset CPP";
}

// optionalAttrs (cross != null && cross.libc == "msvcrt" && crossStageStatic) {
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
    homepage = "http://ghdl.free.fr/";
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Complete VHDL simulator, using the GCC technology (gcc ${version})";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

})
