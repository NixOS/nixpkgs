{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, langJava ? false
, profiledCompiler ? false
, staticCompiler ? false
, texinfo ? null
, gmp, mpfr
, bison ? null, flex ? null
, zlib ? null, boehmgc ? null
, enableMultilib ? false
, name ? "gcc"
}:

assert langTreelang -> bison != null && flex != null;

with stdenv.lib;

let version = "4.3.3"; in

stdenv.mkDerivation ({
  name = "${name}-${version}";
  
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "08yksvipnqmqbmif30rwjkg3y0m6ray5r84wa2argv8q0bpz9426";
    }) ++
    optional langCC (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "12z2zh03yq214qs2cqzh8c64jjfz544nk1lzi9rygjwm8yjsvzm9";
    }) ++
    optional langFortran (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "1b2wbysviyh7l9fqbd6zy5y6y89xgysy99gr8wx8xkc1hy2nwdsq";
    }) ++
    optional langJava (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
      sha256 = "1mlazpydd9qv7zwxkbb5sw3clfawfndhcc3f5lzycminvn6qmfkb";
    });
    
  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs ./no-sys-dirs.patch
    ++ optional (noSysDirs && langFortran) ./no-sys-dirs-fortran.patch;
    
  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = [texinfo gmp mpfr]
    ++ (optionals langTreelang [bison flex])
    ++ (optional (zlib != null) zlib)
    ++ (optional (boehmgc != null) boehmgc)
    ;

  configureFlags = "
    ${if enableMultilib then "" else "--disable-multilib"}
    --disable-libstdcxx-pch
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
    description = "GNU Compiler Collection, 4.3.x";
  };
} // (if langJava then {
  postConfigure = ''
    make configure-gcc
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${zlib}/include@ ; s@^LDFLAGS = .*@& -L${zlib}/lib@'
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${boehmgc}/include@ ; s@^LDFLAGS = .*@& -L${boehmgc}/lib -lgc@'
  '';
} else {}))
