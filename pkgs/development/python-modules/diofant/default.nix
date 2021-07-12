{ lib
, buildPythonPackage
, fetchPypi
, gmpy2
, isort
, mpmath
, numpy
, pythonOlder
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "diofant";
  version = "0.12.0";
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "Diofant";
    sha256 = "sha256-G0CTSoDSduiWxlrk5XjnX5ldNZ9f7yxaJeUPO3ezJgo=";
  };

  nativeBuildInputs = [
    isort
    setuptools-scm
  ];

  propagatedBuildInputs = [
    gmpy2
    mpmath
    numpy
    scipy
  ];

  # tests take ~1h
  doCheck = false;

  pythonImportsCheck = [ "diofant" ];

  meta = with lib; {
    description = "A Python CAS library";
    homepage = "https://diofant.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ suhr ];
  };
}
