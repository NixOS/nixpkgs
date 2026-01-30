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
  version = "0.9.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w01tzw/i66WJb3HJbTehwP4aYfCEQPoM/Ow9woldMwI=";
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

  meta = {
    description = "Python library for reading and writing collada documents";
    homepage = "http://pycollada.github.io/";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
