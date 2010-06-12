{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, langJava ? false
, langAda ? false
, langVhdl ? false
, profiledCompiler ? false
, staticCompiler ? false
, enableShared ? true
, texinfo ? null
, gmp, mpfr, gettext, which
, ppl ? null, cloogppl ? null  # used by the Graphite optimization framework
, bison ? null, flex ? null
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
}:

assert langTreelang -> bison != null && flex != null;
assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null;
assert langAda      -> gnatboot != null;
assert langVhdl     -> gnat != null;

with stdenv.lib;

let version = "4.4.3";
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

    crossConfigureFlags =
      "--target=${cross.config}" +
      withArch +
      withCpu +
      withAbi +
      (if crossStageStatic then
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
        " --enable-threads=posix" +
        " --enable-nls" +
        " --disable-decimal-float" # No final libdecnumber (it may work only in 386)
        );
    stageNameAddon = if (crossStageStatic) then "-stage-static" else
      "-stage-final";
    crossNameAddon = if (cross != null) then "-${cross.config}" + stageNameAddon else "";

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
    [./pass-cxxcpp.patch

     # libmudflap and libstdc++ receive the build CPP,
     # and not the target.
     # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=42279
     ./target-cpp.patch

     # Bad mixture of build/target flags
     ./libstdc++-target.patch
     ]
    ++ optional noSysDirs ./no-sys-dirs.patch
    # The GNAT Makefiles did not pay attention to CFLAGS_FOR_TARGET for its
    # target libraries and tools.
    ++ optional langAda ./gnat-cflags.patch
    ++ optional langVhdl ./ghdl-ortho-cflags.patch
    ++ optional (cross != null && cross.arch == "sparc64") ./pr41818.patch;

  inherit noSysDirs profiledCompiler staticCompiler langJava crossStageStatic
    libcCross;

  buildInputs = [ texinfo gmp mpfr gettext which ]
    ++ (optional (ppl != null) ppl)
    ++ (optional (cloogppl != null) cloogppl)
    ++ (optionals langTreelang [bison flex])
    ++ (optional (zlib != null) zlib)
    ++ (optional (boehmgc != null) boehmgc)
    ++ (optionals langJava [zip unzip])
    ++ (optionals javaAwtGtk [gtk pkgconfig libart_lgpl] ++ xlibs)
    ++ (optionals (cross != null) [binutilsCross])
    ++ (optionals langAda [gnatboot])
    ++ (optionals langVhdl [gnat])
    ;

  configureFlags = "
    ${if enableMultilib then "" else "--disable-multilib"}
    ${if enableShared then "" else "--disable-shared"}
    ${if ppl != null then "--with-ppl=${ppl}" else ""}
    ${if cloogppl != null then "--with-cloog=${cloogppl}" else ""}
    ${if langJava then "--with-ecj-jar=${javaEcj}" else ""}
    ${if javaAwtGtk then "--enable-java-awt=gtk" else ""}
    ${if langJava && javaAntlr != null then "--with-antlr-jar=${javaAntlr}" else ""}
    --with-gmp=${gmp}
    --with-mpfr=${mpfr}
    --disable-libstdcxx-pch
    --without-included-gettext
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC        "c"
        ++ optional langCC       "c++"
        ++ optional langFortran  "fortran"
        ++ optional langJava     "java"
        ++ optional langTreelang "treelang"
        ++ optional langAda      "ada"
        ++ optional langVhdl     "vhdl"
        )
      )
    }
    ${if langAda then " --enable-libada" else ""}
    ${if (cross == null && stdenv.isi686) then "--with-arch=i686" else ""}
    ${if cross != null then crossConfigureFlags else ""}
  ";

  targetConfig = if (cross != null) then cross.config else null;

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

  CPATH = concatStrings
            (intersperse ":" (map (x: x + "/include")
                                  (optionals langJava [ boehmgc zlib ]
                                   ++ optionals javaAwtGtk xlibs
                                   ++ optionals javaAwtGtk [ gmp mpfr ])));

  LIBRARY_PATH = concatStrings
                   (intersperse ":" (map (x: x + "/lib")
                                         (optionals langJava [ boehmgc zlib ]
                                          ++ optionals javaAwtGtk xlibs
                                          ++ optionals javaAwtGtk [ gmp mpfr ])));


  passthru = { inherit langC langCC langAda langFortran langTreelang langVhdl
      enableMultilib version; };

  meta = {
    homepage = http://gcc.gnu.org/;
    license = "GPLv3+";  # runtime support libraries are typically LGPLv3+
    description = "GNU Compiler Collection, version ${version}";

    longDescription = ''
      The GNU Compiler Collection includes compiler front ends for C, C++,
      Objective-C, Fortran, OpenMP for C/C++/Fortran, Java, and Ada, as well
      as libraries for these languages (libstdc++, libgcj, libgomp,...).

      GCC development is a part of the GNU Project, aiming to improve the
      compiler used in the GNU system including the GNU/Linux variant.
    '';

    maintainers = [
      # Add your name here!
      stdenv.lib.maintainers.ludo
      stdenv.lib.maintainers.viric
    ];

    # Volunteers needed for the {Cyg,Dar}win ports of *PPL.
    # gnatboot is not available out of linux platforms, so we disable the darwin build
    # for the gnat (ada compiler).
    platforms = stdenv.lib.platforms.linux ++ optionals (langAda == false) [ "i686-darwin" ];
  };
}
// (if langVhdl then rec {
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
    license = "GPLv2+";
    description = "Complete VHDL simulator, using the GCC technology (gcc ${version})";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

} else {}))
