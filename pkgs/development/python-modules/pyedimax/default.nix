{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyedimax";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M5cVQjqPZCQMKS8vv+xw2x6KlRqB6mOezwLi53fJb8Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyedimax" ];

  meta = {
    description = "Python library for interfacing with the Edimax smart plugs";
    homepage = "https://github.com/andreipop2005/pyedimax";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
