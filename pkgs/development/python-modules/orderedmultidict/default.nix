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
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FqeuhDLgLMmH0tbVry31k4JY+HyHBnXHPud6CSDm9KY=";
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
