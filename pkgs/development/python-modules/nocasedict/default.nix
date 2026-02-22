{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "2.2.0a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pywbem";
    repo = "nocasedict";
    tag = version;
    hash = "sha256-crmcWMBXF4uUdodZSy5rFEmm5TNiWdjdzYd4a+u64U4=";
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
    changelog = "https://github.com/pywbem/nocasedict/blob/${src.tag}/docs/changes.rst";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
