{stdenv, fetchurl, autoreconfHook, givaro_3_7, pkgconfig, openblas, gmpxx}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fflas-ffpack";
  version = "1.6.0";
  src = fetchurl {
    url = "http://linalg.org/fflas-ffpack-${version}.tar.gz";
    sha256 = "02fr675278c65hfiy1chb903j4ix9i8yni1xc2g5nmsjcaf9vra9";
  };
  buildInputs = [autoreconfHook givaro_3_7 openblas gmpxx];
  nativeBuildInputs = [pkgconfig];
  configureFlags = "--with-blas=-lopenblas --with-gmp=${gmpxx.dev} --with-givaro=${givaro_3_7}";
  meta = {
    inherit version;
    description = ''Finite Field Linear Algebra Subroutines'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://linbox-team.github.io/fflas-ffpack/;
  };
}
