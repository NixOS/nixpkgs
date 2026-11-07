{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  cysignals,
  primecount,
  primesieve,
  lib,
}:
buildPythonPackage rec {
  pname = "passagemath-primesieve-primecount";
  version = "0.1.1.2";

  pyproject = true;
  build-system = [
    setuptools
    cython
    cysignals
  ];
  nativeBuildInputs = [
    primecount
    primesieve
  ];
  buildInputs = [
    primecount
    primesieve
  ];
  dependencies = [ cysignals ];

  src = fetchPypi {
    pname = "passagemath_primesieve_primecount";
    inherit version;
    hash = "sha256-77Qgj7hNsRgzb2bahWrXj3X8Ddei4oumPtbN+BPOwI0=";
  };

  pythonImportsCheck = [ "primecountpy" ];
}
