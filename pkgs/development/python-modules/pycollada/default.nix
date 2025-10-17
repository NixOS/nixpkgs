{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  numpy,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "pycollada";
  version = "0.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fKEiZ74KK5PkldYDbmsnQCOpRX3tZBlU6wxHDv4VPW4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    python-dateutil
  ];

  # Some tests fail because they refer to test data files that don't exist
  # (upstream packaging issue)
  doCheck = false;

  pythonImportsCheck = [
    "collada"
  ];

  meta = with lib; {
    description = "Python library for reading and writing collada documents";
    homepage = "http://pycollada.github.io/";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
}
