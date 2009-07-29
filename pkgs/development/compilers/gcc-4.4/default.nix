{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, langJava ? false
, profiledCompiler ? false
, staticCompiler ? false
, texinfo ? null
, gmp, mpfr, gettext, which
, ppl ? null, cloogppl ? null  # used by the Graphite optimization framework
, bison ? null, flex ? null
, zlib ? null, boehmgc ? null
, zip ? null, unzip ? null, pkgconfig ? null, gtk ? null, libart_lgpl ? null
, libX11 ? null, libXt ? null, libSM ? null, libICE ? null, libXtst ? null
, enableMultilib ? false
, name ? "gcc"
}:

assert langTreelang -> bison != null && flex != null;
assert langJava     -> zip != null && unzip != null;
assert gtk != null  -> pkgconfig != null && libart_lgpl != null
                       && libX11 != null && libXt != null && libSM != null
                       && libICE != null && libXtst != null;

with stdenv.lib;

let version = "4.4.1";
    javaEcj = fetchurl {
      # The `$(top_srcdir)/ecj.jar' file is automatically picked up at
      # `configure' time.

      # XXX: Eventually we might want to take it from upstream.
      url = "ftp://sourceware.org/pub/java/ecj-4.3.jar";
      sha256 = "0jz7hvc0s6iydmhgh5h2m15yza7p2rlss2vkif30vm9y77m97qcx";
    };

in

stdenv.mkDerivation ({
  name = "${name}-${version}";

  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "0jgwa98i964jhnjg6acvvhz0wb51v00kk3gal8qbps8j09g2mgag";
    }) ++


    optional langCC (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "1pfgfgpvkq0i4023n4v1cghzmcq8c15xn4n967n29vmdrrwk8754";
    }) ++

    optional langFortran (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "1406r8ndl7pjyas5naw8ygqpfrl72ypyn71llfzf953j736kmi50";
    }) ++

    optional langJava (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
      sha256 = "07lgph5zxskqqkzbq67wma2067dqr5my110l8rgzspqjq5rhgdil";
    });

  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs ./no-sys-dirs.patch;

  inherit noSysDirs profiledCompiler staticCompiler langJava;

  buildInputs = [ texinfo gmp mpfr gettext which ]
    ++ (optional (ppl != null) ppl)
    ++ (optional (cloogppl != null) cloogppl)
    ++ (optionals langTreelang [bison flex])
    ++ (optional (zlib != null) zlib)
    ++ (optional (boehmgc != null) boehmgc)
    ++ (optionals langJava [zip unzip])
    ++ (optionals (gtk != null)
         [gtk pkgconfig libart_lgpl libX11 libXt libSM libICE libXtst])
    ;

  configureFlags = "
    ${if enableMultilib then "" else "--disable-multilib"}
    ${if ppl != null then "--with-ppl=${ppl}" else ""}
    ${if cloogppl != null then "--with-cloog=${cloogppl}" else ""}
    ${if langJava then "--with-ecj-jar=${javaEcj}" else ""}
    ${if (langJava && gtk != null) then "--enable-java-awt=gtk" else ""}
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

  inherit gmp mpfr zlib boehmgc;
  inherit libX11 libXt libSM libICE libXtst;

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
  };
})
