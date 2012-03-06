{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false
, profiledCompiler ? false
, staticCompiler ? false
, gmp ? null
, mpfr ? null
, texinfo ? null
, name ? "gcc"
}:

assert langC || langFortran;

with stdenv.lib;

stdenv.mkDerivation {
  name = "${name}-4.1.2";
  
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.1.2/gcc-core-4.1.2.tar.bz2;
      sha256 = "07binc1hqlr0g387zrg5sp57i12yzd5ja2lgjb83bbh0h3gwbsbv";
    }) ++
    optional /*langCC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.1.2/gcc-g++-4.1.2.tar.bz2;
      sha256 = "1qm2izcxna10jai0v4s41myki0xkw9174qpl6k1rnrqhbx0sl1hc";
    }) ++
    optional langFortran (fetchurl {
      url = mirror://gnu/gcc/gcc-4.1.2/gcc-fortran-4.1.2.tar.bz2;
      sha256 = "0772dhmm4gc10420h0d0mfkk2sirvjmjxz8j0ywm8wp5qf8vdi9z";
    });
    
  patches =
    optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = [gmp mpfr texinfo];

  enableParallelBuilding = true;
  
  configureFlags = "
    --disable-multilib
    --disable-libstdcxx-pch
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC       "c"
        ++ optional langCC      "c++"
        ++ optional langFortran "fortran"
        )
      )
    }
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
  ";

  makeFlags = if staticCompiler then "LDFLAGS=-static" else "";

  passthru = { inherit langC langCC langFortran; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.1.x";

    # Give the real GCC a lower priority than the GCC wrapper so that
    # both can be installed at the same time.
    priority = "7";
  };
}
