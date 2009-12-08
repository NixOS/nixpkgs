{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, langJava ? false
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
, enableMultilib ? false
, name ? "gcc"
, cross ? null
, binutilsCross ? null
, libcCross ? null
, crossStageStatic ? true
}:

assert langTreelang -> bison != null && flex != null;
assert langJava     -> zip != null && unzip != null
                       && zlib != null && boehmgc != null;

with stdenv.lib;

let version = "4.4.2";
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

    crossConfigureFlags =
      "--target=${cross.config}" +
      (if crossStageStatic then
        " --disable-libssp --disable-nls" +
        " --without-headers" +
        " --disable-threads " +
        " --disable-libmudflap " +
        " --disable-libgomp " +
        " --disable-shared"
        else
        " --with-headers=${libcCross}/include" +
        " --enable-__cxa_atexit" +
        " --enable-long-long" +
        " --enable-threads=posix" +
        " --enable-nls"
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
    inherit langC langCC langFortran langJava;
  };

  patches =
    [./pass-cxxcpp.patch
     ./libtool-glibc.patch   # some libraries don't let the proper -Btargetglibcpath pass
     ./libstdc++-target.patch # (fixed in gcc 4.4.3) bad mixture of build/target flags
     ]
    ++ optional noSysDirs ./no-sys-dirs.patch;

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
        )
      )
    }
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
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


  passthru = { inherit langC langCC langFortran langTreelang enableMultilib; };

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
    ];

    # Volunteers needed for the {Cyg,Dar}win ports.
    platforms = stdenv.lib.platforms.linux;
  };
})
