{ stdenv
, fetchurl
, fetchpatch
, gmp
, mpir
, mpfr
, ntl
, openblas ? null
, withBlas ? true
}:

assert withBlas -> openblas != null;

stdenv.mkDerivation rec {
  name = "flint-${version}";
  version = "2.5.2"; # remove libflint.so.MAJOR patch when updating
  src = fetchurl {
    url = "http://www.flintlib.org/flint-${version}.tar.gz";
    sha256 = "11syazv1a8rrnac3wj3hnyhhflpqcmq02q8pqk2m6g2k6h0gxwfb";
  };
  buildInputs = [
    gmp
    mpir
    mpfr
    ntl
  ] ++ stdenv.lib.optionals withBlas [
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
  ] ++ stdenv.lib.optionals withBlas [
    "--with-blas=${openblas}"
  ];

  # issues with ntl -- https://github.com/wbhart/flint2/issues/487
  NIX_CXXSTDLIB_COMPILE = [ "-std=c++11" ];

  patches = [
    (fetchpatch {
      # Always produce libflint.so.MAJOR; will be included in the next flint version
      # See https://github.com/wbhart/flint2/pull/347
      url = "https://github.com/wbhart/flint2/commit/49fbcd8f736f847d3f9667f9f7d5567ef4550ecb.patch";
      sha256 = "09w09bpq85kjf752bd3y3i5lvy59b8xjiy7qmrcxzibx2a21pj73";
    })
  ];
  doCheck = true;
  meta = {
    inherit version;
    description = ''Fast Library for Number Theory'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = http://www.flintlib.org/;
    downloadPage = "http://www.flintlib.org/downloads.html";
    updateWalker = true;
  };
}
