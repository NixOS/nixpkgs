{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, staticCompiler ? false
, gmp ? null
, mpfr ? null
, texinfo ? null
}:

assert langC || langF77;

with import ../../../lib;

let version = "4.2.3"; in

stdenv.mkDerivation {
  name = "gcc-${version}";
  builder = if langF77 then ./fortran.sh else  ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "04y84s46wzy4h44hpacf7vyla7b5zfc1qvdq3myvrhp82cp0bv4r";
    }) ++
    optional langCC (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "0spzz549fifwv02ym33azzwizl0zkq5m1fgy88ccmcyzmwpgyzfq";
    }) ++
    optional langF77 (fetchurl {
      url = "mirror://gnu/gcc/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "1l3ww6qymrkcfqlssb41a5fdnh6w2hqk0v2ijx56jgjbdnzawyp0";
    });
    
  patches =
    optional noSysDirs [./no-sys-dirs.patch];
    
  inherit noSysDirs profiledCompiler staticCompiler;

  buildInputs = [gmp mpfr texinfo];
  
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
    ${if gmp != null then "--with-gmp=${gmp}" else ""}
    ${if mpfr != null then "--with-mpfr=${mpfr}" else ""}
  ";

  makeFlags = if staticCompiler then "LDFLAGS=-static" else "";

  passthru = { inherit langC langCC langF77; };

  postInstall = "if test -f $out/bin/gfrotran; then ln -s $out/bin/gfortran $out/bin/g77; fi";

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.2.x";

    # Give the real GCC a lower priority than the GCC wrapper so that
    # both can be installed at the same time.
    priority = "7";
  };
}
