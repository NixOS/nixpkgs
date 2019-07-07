{ lib
, fetchFromGitHub
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
  version = "0.4.1dev";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fpylll";
    rev = version;
    sha256 = "01x2sqdv0sbjj4g4waj0hj4rcn4bq7h17442xaqwbznym9azmn9w";
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
