{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyedimax";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M5cVQjqPZCQMKS8vv+xw2x6KlRqB6mOezwLi53fJb8Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyedimax" ];

  meta = with lib; {
    description = "Python library for interfacing with the Edimax smart plugs";
    homepage = "https://github.com/andreipop2005/pyedimax";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
