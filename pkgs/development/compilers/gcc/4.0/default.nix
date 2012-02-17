{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, profiledCompiler ? false
, gmp ? null , mpfr ? null
, texinfo ? null
, name ? "gcc"
}:

assert langC;

with stdenv.lib;

stdenv.mkDerivation {
  name = "${name}-4.0.4";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-4.0.4/gcc-4.0.4.tar.bz2;
    sha256 = "0izwr8d69ld3a1yr8z94s7y7k861wi613mplys2c0bvdr58y1zgk";
  };
  
  patches =
    optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs langC langCC langFortran profiledCompiler;

  buildInputs = [gmp mpfr texinfo];

  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --disable-libmudflap
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC       "c"
        ++ optional langCC      "c++"
        ++ optional langFortran "f95"
        )
      )
    }
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
  ";

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.0.x";
  };
}
