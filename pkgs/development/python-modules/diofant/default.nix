{
  lib,
  buildPythonPackage,
  cython,
  fetchpatch,
  fetchPypi,
  gmpy2,
  mpmath,
  numpy,
  pythonOlder,
  scipy,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "diofant";
  version = "0.15.0";
  format = "pyproject";
  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit version;
    pname = "Diofant";
    hash = "sha256-noh9qJXjx+GJH+XZ8jHS3IGeOuBf54BXVXnS1p8RGoc=";
  };

  patches = [
    (fetchpatch {
      name = "remove-pip-from-build-dependencies.patch";
      url = "https://github.com/diofant/diofant/commit/117e441808faa7c785ccb81bf211772d60ebdec3.patch";
      hash = "sha256-MYk1Ku4F3hAv7+jJQLWhXd8qyKRX+QYuBzPfYWT0VbU=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ mpmath ];

  optional-dependencies = {
    exports = [
      cython
      numpy
      scipy
    ];
    gmpy = [ gmpy2 ];
  };

  # tests take ~1h
  doCheck = false;

  pythonImportsCheck = [ "diofant" ];

  meta = with lib; {
    description = "Python CAS library";
    homepage = "https://diofant.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ suhr ];
  };
}
