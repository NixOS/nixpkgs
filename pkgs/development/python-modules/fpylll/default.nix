{ lib
, fetchPypi
, buildPythonPackage
, pkgconfig
, gmp
, pari
, mpfr
, fplll
, cython
, cysignals
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "fpylll";
  version = "0.3.0dev";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bjkh02fnxsrxwjzai8ij12zl2wq319z8y25sn9pvvzla5izgnp9";
  };

  buildInputs = [
    gmp
    pari
    mpfr
    fplll
  ];

  propagatedBuildInputs = [
    cython
    cysignals
    numpy
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "A Python interface for fplll";
    homepage = https://github.com/fplll/fpylll;
    maintainers = with lib.maintainers; [ timokau ];
    license = lib.licenses.gpl2Plus;
  };
}
