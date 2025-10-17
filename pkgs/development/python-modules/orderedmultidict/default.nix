{
  lib,
  buildPythonPackage,
  fetchPypi,
  flake8,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "orderedmultidict";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BAcLu16HKRzJv6Ud9BNnf68hQcc8YdKl97Jr6jzYgq0=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "orderedmultidict" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Ordered Multivalue Dictionary";
    homepage = "https://github.com/gruns/orderedmultidict";
    license = lib.licenses.unlicense;
  };
}
