{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, staticCompiler ? false
, gmp ? null
, mpfr ? null
}:

assert langC || langF77;

with import ../../../lib;

stdenv.mkDerivation ({
  name = "gcc-4.1.2";
  builder = if langF77 then ./fortran.sh else  ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.1.2/gcc-core-4.1.2.tar.bz2;
      sha256 = "07binc1hqlr0g387zrg5sp57i12yzd5ja2lgjb83bbh0h3gwbsbv";
    }) ++
    optional /*langCC*/ true (fetchurl {
      url = mirror://gnu/gcc/gcc-4.1.2/gcc-g++-4.1.2.tar.bz2;
      sha256 = "1qm2izcxna10jai0v4s41myki0xkw9174qpl6k1rnrqhbx0sl1hc";
    }) ++
    optional langF77 (fetchurl {
      url = mirror://gnu/gcc/gcc-4.1.2/gcc-fortran-4.1.2.tar.bz2;
      sha256 = "0772dhmm4gc10420h0d0mfkk2sirvjmjxz8j0ywm8wp5qf8vdi9z";
    });
    
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
        ++ optional langF77 "fortran"
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

// (if gmp != null || mpfr != null then {
  buildInputs = []
    ++ (if gmp != null then [gmp] else [])
    ++ (if mpfr != null then [mpfr] else []);
} else {}))
