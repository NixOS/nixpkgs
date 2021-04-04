{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mpmath";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79ffb45cf9f4b101a807595bcb3e72e0396202e0b1d25d689134b48c4216a81a";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # error: invalid command 'test'
  doCheck = false;

  meta = with lib; {
    homepage    = "https://mpmath.org/";
    description = "A pure-Python library for multiprecision floating arithmetic";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
