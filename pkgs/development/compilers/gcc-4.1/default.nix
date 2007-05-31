{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, staticCompiler ? false
}:

assert langC;

with import ../../../lib;

stdenv.mkDerivation {
  name = "gcc-4.1.2";
  builder = ./builder.sh;
  
  src =
    [(fetchurl {
      url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-4.1.2/gcc-core-4.1.2.tar.bz2;
      sha256 = "07binc1hqlr0g387zrg5sp57i12yzd5ja2lgjb83bbh0h3gwbsbv";
    })] ++
    (if /*langCC*/ true then [(fetchurl {
      url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-4.1.2/gcc-g++-4.1.2.tar.bz2;
      sha256 = "1qm2izcxna10jai0v4s41myki0xkw9174qpl6k1rnrqhbx0sl1hc";
    })] else []) ++
    (if langF77 then [(fetchurl {
      url = ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-4.1.2/gcc-fortran-4.1.2.tar.bz2;
      sha256 = "0772dhmm4gc10420h0d0mfkk2sirvjmjxz8j0ywm8wp5qf8vdi9z";
    })] else []);
    
  patches =
    optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs profiledCompiler staticCompiler;

  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
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

  makeFlags = if staticCompiler then "LDFLAGS=-static" else "";

  passthru = { inherit langC langCC langF77; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.1.x";

    # Give the real GCC a lower priority than the GCC wrapper so that
    # both can be installed at the same time.
    priority = "7";
  };
}
