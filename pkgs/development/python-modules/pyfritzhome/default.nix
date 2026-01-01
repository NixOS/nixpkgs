{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfritzhome";
<<<<<<< HEAD
  version = "0.6.18";
  pyproject = true;

=======
  version = "0.6.17";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-tWWX3rUmESWOkiWU6Y8KIinbPUhBdolSHZ+5Rv2dnuY=";
=======
    hash = "sha256-NYxrw+kkCWhU79nU1t50tGISHUx3sWE/af094Q0ag4I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfritzhome" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    mainProgram = "fritzhome";
    homepage = "https://github.com/hthiery/python-fritzhome";
    changelog = "https://github.com/hthiery/python-fritzhome/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
