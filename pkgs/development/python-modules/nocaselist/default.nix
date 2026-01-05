{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+3MG9aPgRVNOc3q37L7uA5ul6br7xbXyMfYW1+khG2U=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nocaselist" ];

  meta = with lib; {
    description = "Case-insensitive list for Python";
    homepage = "https://github.com/pywbem/nocaselist";
    changelog = "https://github.com/pywbem/nocaselist/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
