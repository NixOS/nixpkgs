{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "repoze-lru";
  version = "0.7";
  pyproject = true;

  src = fetchPypi {
    pname = "repoze.lru";
    inherit version;
    hash = "sha256-BCmnXhk4Dk7VDAaU4mrIgZtOp4Ue4fx1g8hXLbgK/3c=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "repoze/lru/tests.py" ];

  disabledTests = [
    # time sensitive tests
    "test_different_timeouts"
    "test_renew_timeout"
  ];

  pythonImportsCheck = [ "repoze.lru" ];

  pythonNamespaces = [ "repoze" ];

  meta = with lib; {
    description = "Tiny LRU cache implementation and decorator";
    homepage = "http://www.repoze.org/";
    changelog = "https://github.com/repoze/repoze.lru/blob/${version}/CHANGES.rst";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
