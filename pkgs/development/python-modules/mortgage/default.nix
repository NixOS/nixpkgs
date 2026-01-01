{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mortgage";
  version = "1.0.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jlumbroso";
    repo = "mortgage";
    tag = "v${version}";
    hash = "sha256-UwSEKfMQqxpcF+7TF/+qD6l8gEO/qDCUklpZz1Nt/Ok=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mortgage" ];

<<<<<<< HEAD
  meta = {
    description = "Mortgage calculator";
    homepage = "https://github.com/jlumbroso/mortgage";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Mortgage calculator";
    homepage = "https://github.com/jlumbroso/mortgage";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
