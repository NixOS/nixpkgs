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

let version = "4.3.2"; in

stdenv.mkDerivation {
  name = "gcc-${version}";
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "0np7cbqdaajarwwlkvq7d2ifkld1lsh0cfsaqcx9dsvqklkyg1q6";
    }) ++
    optional langCC (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "105vhmq111l5zyzxdanhhv5lgvl4pr6pq9xj6jb5g5x3bk4jnki5";
    }) ++
    optional langFortran (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "1kk3d2n68va5wxpi77cadn4s5b7s39qg1dqyrfppq1nrqwb77acl";
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
