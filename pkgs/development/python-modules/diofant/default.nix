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
  version = "0.14.0";
  format = "pyproject";
  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit version;
    pname = "Diofant";
    hash = "sha256-c886y37xR+4TxZw9+3tb7nkTGxWcS+Ag/ruUUdpf7S4=";
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

  passthru.optional-dependencies = {
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
