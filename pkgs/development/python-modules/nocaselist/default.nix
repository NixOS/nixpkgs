{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sGs9b+wavAXGB6qOgTWZOIcnoI4YwiNDHXRpz26wwGo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nocaselist" ];

  meta = {
    description = "Case-insensitive list for Python";
    homepage = "https://github.com/pywbem/nocaselist";
    changelog = "https://github.com/pywbem/nocaselist/blob/${version}/docs/changes.rst";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
