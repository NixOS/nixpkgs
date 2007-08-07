{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
}:

assert langC;

with import ../../../lib;

stdenv.mkDerivation {
  name = "gcc-4.0.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-4.0.4/gcc-4.0.4.tar.bz2;
    sha256 = "0izwr8d69ld3a1yr8z94s7y7k861wi613mplys2c0bvdr58y1zgk";
  };
  
  patches =
    optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs langC langCC langF77 profiledCompiler;

  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --disable-libmudflap
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC   "c"
        ++ optional langCC  "c++"
        ++ optional langF77 "f77"
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
