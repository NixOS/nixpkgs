{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  numpy,
  pytest-asyncio,
  dill,
}:

buildPythonPackage rec {
  pname = "memoshelve";
  version = "1.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JW1Uxr/4skPr8u4JzNZ+rpoSuE5q9eYsI0Tl47dkIgk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pytest-asyncio
    dill
  ];
  pythonImportsCheck = [ "memoshelve" ];

  meta = with lib; {
    description = "Python memoization library with shelve backend";
    homepage = "https://pypi.org/project/memoshelve/";
    license = licenses.mit;
  };
}
