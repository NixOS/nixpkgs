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
  version = "3.0.1";

  src = fetchurl {
    url = "https://www.flintlib.org/flint-${version}.tar.gz";
    sha256 = "sha256-ezEaAFA6hjiB64F32+uEMi8pOZ89fXLzsaTJuh1XlLQ=";
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

  enableParallelBuilding = true;

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
