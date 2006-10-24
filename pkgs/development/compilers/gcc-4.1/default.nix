{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, staticCompiler ? false
}:

assert langC;

stdenv.mkDerivation {
  name = "gcc-4.1.1";
  builder = ./builder.sh;
  
  src =
    [(fetchurl {
      url = http://ftp.gnu.org/pub/gnu/gcc/gcc-4.1.1/gcc-core-4.1.1.tar.bz2;
      md5 = "a1b189c98aa7d7f164036bbe89b9b2a2";
    })] ++
    (if langCC then [(fetchurl {
      url = http://ftp.gnu.org/pub/gnu/gcc/gcc-4.1.1/gcc-g++-4.1.1.tar.bz2;
      md5 = "70c786bf8ca042e880a87fecb9e4dfcd";
    })] else []) ++
    (if langF77 then [(fetchurl {
      url = http://ftp.gnu.org/pub/gnu/gcc/gcc-4.1.1/gcc-fortran-4.1.1.tar.bz2;
      md5 = "b088a28a1963d16bf505262f8bfd09db";
    })] else []);
    
  patches =
    [./pass-cxxcpp.patch]
    ++ (if noSysDirs then [./no-sys-dirs.patch] else []);
    
  inherit noSysDirs langC langCC langF77 profiledCompiler;

  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --disable-libmudflap
    --disable-libssp
  ";

  makeFlags = if staticCompiler then "LDFLAGS=-static" else "";

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.1.x";
  };
}
