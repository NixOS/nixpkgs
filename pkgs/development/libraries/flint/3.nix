{ lib
, stdenv
, fetchurl
, gmp
, mpfr
, ntl
, autoconf
, automake
, gettext
, libtool
, openblas ? null, blas, lapack
, withBlas ? true
, withNtl ? true
}:

assert withBlas -> openblas != null && blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation rec {
  pname = "flint3";
  version = "3.0.1";

  src = fetchurl {
    url = "https://www.flintlib.org/flint-${version}.tar.gz";
    sha256 = "sha256-ezEaAFA6hjiB64F32+uEMi8pOZ89fXLzsaTJuh1XlLQ=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];

  propagatedBuildInputs = [
    mpfr
  ];

  buildInputs = [
    gmp
  ] ++ lib.optionals withBlas [
    openblas
  ] ++ lib.optionals withNtl [
    ntl
  ];

  # We're not using autoreconfHook because flint's bootstrap
  # script calls autoreconf, among other things.
  preConfigurePhase = ''
    echo "Executing bootstrap.sh"
    ./bootstrap.sh
  '';

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpfr=${mpfr}"
  ] ++ lib.optionals withBlas [
    "--with-blas=${openblas}"
  ] ++ lib.optionals withNtl [
    "--with-ntl=${ntl}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Fast Library for Number Theory";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smasher164 ] ++ teams.sage.members;
    platforms = platforms.unix;
    homepage = "https://www.flintlib.org/";
    downloadPage = "https://www.flintlib.org/downloads.html";
  };
}
