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
  version = "0.13.0";
  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "Diofant";
    sha256 = "bac9e086a7156b20f18e3291d6db34e305338039a3c782c585302d377b74dd3c";
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
