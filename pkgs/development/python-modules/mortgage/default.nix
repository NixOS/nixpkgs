{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mortgage";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlumbroso";
    repo = "mortgage";
    tag = "v${version}";
    hash = "sha256-UwSEKfMQqxpcF+7TF/+qD6l8gEO/qDCUklpZz1Nt/Ok=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mortgage" ];

  meta = {
    description = "Mortgage calculator";
    homepage = "https://github.com/jlumbroso/mortgage";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
