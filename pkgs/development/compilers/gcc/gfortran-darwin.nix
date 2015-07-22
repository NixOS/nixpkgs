# This is a derivation specific to OS X (Darwin). It may work on other
# systems as well but has not been tested.
{gmp, mpfr, libmpc, fetchurl, stdenv}:

stdenv.mkDerivation rec {
  name = "gfortran-${version}";
  version = "5.1.0";
  buildInputs = [gmp mpfr libmpc];
  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "1bd5vj4px3s8nlakbgrh38ynxq4s654m6nxz7lrj03mvkkwgvnmp";
  };
  configureFlags = ''
    --enable-languages=fortran --enable-checking=release --disable-bootstrap
    --with-gmp=${gmp}
    --with-mpfr=${mpfr}
    --with-mpc=${libmpc}
  '';
  makeFlags = ["CC=clang"];
  passthru.cc = stdenv.cc.cc;
  meta = with stdenv.lib; {
    description = "GNU Fortran compiler, part of the GNU Compiler Collection.";
    homepage    = "https://gcc.gnu.org/fortran/";
    license     = licenses.gpl3Plus;
    platforms   = platforms.darwin;
  };
}
