{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tWPVhRy7DgsQ+7YYm6h+BhLSLlpvOgBKRXOrWziqqn0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nocasedict" ];

  meta = with lib; {
    description = "Case-insensitive ordered dictionary for Python";
    homepage = "https://github.com/pywbem/nocasedict";
    changelog = "https://github.com/pywbem/nocasedict/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
