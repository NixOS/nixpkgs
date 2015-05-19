# This is a derivation customized to work on OS X (Darwin).
{gmp, mpfr, libmpc, fetchurl, stdenv}:

# This package is only intended for OSX.
assert stdenv.isDarwin;

stdenv.mkDerivation rec {
  name = "gfortran";
  version = "5.1.0";
  buildInputs = [gmp mpfr libmpc];
  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gcc/gcc-${version}/gcc-${version}.tar.bz2";
    sha256 = "1bd5vj4px3s8nlakbgrh38ynxq4s654m6nxz7lrj03mvkkwgvnmp";
  };
  configureFlags = ''
    --enable-languages=fortran --enable-checking=release --disable-bootstrap
    --with-gmp=${gmp}
    --with-mpfr=${mpfr}
    --with-mpc=${libmpc}
  '';
  makeFlags = ["CC=clang"];
}
