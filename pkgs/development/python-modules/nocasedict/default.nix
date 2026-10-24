{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nocasedict";
  version = "2.3.0a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pywbem";
    repo = "nocasedict";
    tag = finalAttrs.version;
    hash = "sha256-kdgrYm3w0HmSnKkSt/pfvir97phgsTj6AZ6Qaz6EjgE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nocasedict" ];

  meta = {
    description = "Case-insensitive ordered dictionary for Python";
    homepage = "https://github.com/pywbem/nocasedict";
    changelog = "https://github.com/pywbem/nocasedict/blob/${finalAttrs.src.tag}/docs/changes.rst";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
})
