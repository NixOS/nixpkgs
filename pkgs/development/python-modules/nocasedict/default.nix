{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "nocasedict";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pywbem";
    repo = "nocasedict";
    tag = finalAttrs.version;
    hash = "sha256-e3APYlmeoby0CGoEh4g6ZK27DwWi4EZdpwsRORxly+w=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
