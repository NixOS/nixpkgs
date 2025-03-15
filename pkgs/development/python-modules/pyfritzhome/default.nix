{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfritzhome";
  version = "0.6.17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    tag = version;
    hash = "sha256-NYxrw+kkCWhU79nU1t50tGISHUx3sWE/af094Q0ag4I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfritzhome" ];

  meta = with lib; {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    mainProgram = "fritzhome";
    homepage = "https://github.com/hthiery/python-fritzhome";
    changelog = "https://github.com/hthiery/python-fritzhome/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
