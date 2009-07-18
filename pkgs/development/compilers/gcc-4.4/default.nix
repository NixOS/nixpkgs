{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, langJava ? false
, profiledCompiler ? false
, staticCompiler ? false
, texinfo ? null
, gmp, mpfr, gettext
, ppl ? null, cloogppl ? null  # used by the Graphite optimization framework
, bison ? null, flex ? null
, zlib ? null, boehmgc ? null
, enableMultilib ? false
, name ? "gcc"
}:

assert langTreelang -> bison != null && flex != null;

with stdenv.lib;

let version = "4.4.0"; in

stdenv.mkDerivation ({
  name = "${name}-${version}";
  
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "0p0gis4xrw363kf2yxlx2022cnhyy1dgngwvy1z1z2s0238av7v1";
    }) ++


    optional langCC (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "1rdv2fi1vif306yjlxx8a4lh7yc89fi54xyl2p6l60pj9v9xq291";
    }) ++

    /* FIXME: Fortran omitted for now.

    optional langFortran (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "";
    }) ++

     */
    optional langJava (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
      sha256 = "0i60llrllgm4sbplw2rc9b0gi0mxr88la07a72mvlbblzpxn22hb";
    });

  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs ./no-sys-dirs.patch
    ++ optional (noSysDirs && langFortran) ./no-sys-dirs-fortran.patch;

  javaEcj =
    if langJava
    then fetchurl {
        # The `$(top_srcdir)/ecj.jar' file is automatically picked up at
        # `configure' time.

        # XXX: Eventually we might want to take it from upstream.
        url = "ftp://sourceware.org/pub/java/ecj-4.3.jar";
        sha256 = "0jz7hvc0s6iydmhgh5h2m15yza7p2rlss2vkif30vm9y77m97qcx";
      }
    else "";


  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = [ texinfo gmp mpfr gettext ]
    ++ (optional (ppl != null) ppl)
    ++ (optional (cloogppl != null) cloogppl)
    ++ (optionals langTreelang [bison flex])
    ++ (optional (zlib != null) zlib)
    ++ (optional (boehmgc != null) boehmgc)
    ;

  configureFlags = "
    ${if enableMultilib then "" else "--disable-multilib"}
    ${if ppl != null then "--with-ppl=${ppl}" else ""}
    ${if cloogppl != null then "--with-cloog=${cloogppl}" else ""}
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
  ";

  NIX_EXTRA_LDFLAGS = if staticCompiler then "-static" else "";

  inherit gmp mpfr;
  
  passthru = { inherit langC langCC langFortran langTreelang enableMultilib; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, version ${version}";

    maintainers = [
      # Add your name here!
      stdenv.lib.maintainers.ludo
    ];
  };
} // (if langJava then {
  postConfigure = ''
    make configure-gcc
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${zlib}/include@ ; s@^LDFLAGS = .*@& -L${zlib}/lib@'
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${boehmgc}/include@ ; s@^LDFLAGS = .*@& -L${boehmgc}/lib -lgc@'
  '';
} else {}))
