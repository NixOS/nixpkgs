{ lib
, stdenv
, fetchurl
, gmp
, mpir
, mpfr
, ntl
, openblas ? null, blas, lapack
, withBlas ? true
}:

assert withBlas -> openblas != null && blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation rec {
  pname = "flint";
  version = "2.8.4";

  src = fetchurl {
    url = "https://www.flintlib.org/flint-${version}.tar.gz";
    sha256 = "sha256-Yd+S6oyOncaS1Gxx1/UKqgmjPUugjQKheEcwpEXl5L4=";
  };

  buildInputs = [
    gmp
    mpir
    mpfr
    ntl
  ] ++ lib.optionals withBlas [
    openblas
  ];

  propagatedBuildInputs = [
    mpfr # flint.h includes mpfr.h
  ];

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpir=${mpir}"
    "--with-mpfr=${mpfr}"
    "--with-ntl=${ntl}"
  ] ++ lib.optionals withBlas [
    "--with-blas=${openblas}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Fast Library for Number Theory";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
    homepage = "https://www.flintlib.org/";
    downloadPage = "https://www.flintlib.org/downloads.html";
  };
}
