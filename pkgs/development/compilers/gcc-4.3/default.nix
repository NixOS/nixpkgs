{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, profiledCompiler ? false
, staticCompiler ? false
, texinfo ? null
, gmp, mpfr
, bison ? null, flex ? null
, enableMultilib ? false
}:

assert langC;
assert langTreelang -> bison != null && flex != null;

with import ../../../lib;

let version = "4.3.3"; in

stdenv.mkDerivation {
  name = "gcc-${version}";
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
    });
    
  patches =
    [./pass-cxxcpp.patch]
    ++ optional noSysDirs ./no-sys-dirs.patch
    ++ optional (noSysDirs && langFortran) ./no-sys-dirs-fortran.patch;
    
  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = [texinfo gmp mpfr]
    ++ optionals langTreelang [bison flex];

  configureFlags = "
    ${if enableMultilib then "" else "--disable-multilib"}
    --disable-libstdcxx-pch
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC        "c"
        ++ optional langCC       "c++"
        ++ optional langFortran  "fortran"
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
}
