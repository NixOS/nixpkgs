{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "repoze-lru";
  version = "0.8";
  pyproject = true;

  src = fetchPypi {
    pname = "repoze_lru";
    inherit (finalAttrs) version;
    hash = "sha256-olJAjNk/5nDIjWZluW/l1C4HHbolB6HyGh5gmuT6iRo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # time sensitive tests
    "test_different_timeouts"
    "test_renew_timeout"
  ];

  pythonImportsCheck = [ "repoze.lru" ];

  pythonNamespaces = [ "repoze" ];

  meta = {
    description = "Tiny LRU cache implementation and decorator";
    homepage = "http://www.repoze.org/";
    changelog = "https://github.com/repoze/repoze.lru/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
})
