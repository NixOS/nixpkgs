# This is a derivation specific to OS X (Darwin)
{gmp, mpfr, libmpc, isl_0_14, cloog, zlib, fetchurl, stdenv

, Libsystem
}:

stdenv.mkDerivation rec {
  name = "gfortran-${version}";
  version = "5.1.0";

  buildInputs = [ gmp mpfr libmpc isl_0_14 cloog zlib ];

  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "1bd5vj4px3s8nlakbgrh38ynxq4s654m6nxz7lrj03mvkkwgvnmp";
  };

  patches = ./gfortran-darwin.patch;

  hardeningDisable = [ "format" ];

  configureFlags = ''
    --disable-bootstrap
    --disable-cloog-version-check
    --disable-isl-version-check
    --disable-multilib
    --enable-checking=release
    --enable-languages=fortran
    --with-cloog=${cloog}
    --with-gmp=${gmp.dev}
    --with-isl=${isl_0_14}
    --with-mpc=${libmpc}
    --with-mpfr=${mpfr.dev}
    --with-native-system-header-dir=${Libsystem}/include
    --with-system-zlib
  '';

  postConfigure = ''
    export DYLD_LIBRARY_PATH=`pwd`/`uname -m`-apple-darwin`uname -r`/libgcc
  '';

  makeFlags = [ "CC=clang" ];

  passthru.cc = stdenv.cc.cc;

  meta = with stdenv.lib; {
    description = "GNU Fortran compiler, part of the GNU Compiler Collection";
    homepage    = "https://gcc.gnu.org/fortran/";
    license     = licenses.gpl3Plus;
    platforms   = platforms.darwin;
  };
}
