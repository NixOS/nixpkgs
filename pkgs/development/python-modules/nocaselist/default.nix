{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  six,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nocaselist";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ut4OlqEErI3a5JwmGqfCe1ro2UNGYcbNjsFvPNXGd6E=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    six
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nocaselist" ];

  meta = {
    description = "Case-insensitive list for Python";
    homepage = "https://github.com/pywbem/nocaselist";
    changelog = "https://github.com/pywbem/nocaselist/blob/${finalAttrs.version}/docs/changes.rst";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
})
