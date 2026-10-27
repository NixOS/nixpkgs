{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-remotedata";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_remotedata";
    inherit (finalAttrs) version;
    hash = "sha256-rT6qJpH+7MIHGJB2TTDgYhFUdXf5ZeLkQkQ1xdiHJ40=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # These tests require a network connection
    "tests/test_strict_check.py"
  ];

  pythonImportsCheck = [ "pytest_remotedata" ];

  meta = {
    description = "Pytest plugin for controlling remote data access";
    homepage = "https://github.com/astropy/pytest-remotedata";
    changelog = "https://github.com/astropy/pytest-remotedata/blob/v${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
