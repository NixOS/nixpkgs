{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfritzhome";
  version = "0.6.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    tag = version;
    hash = "sha256-tWWX3rUmESWOkiWU6Y8KIinbPUhBdolSHZ+5Rv2dnuY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfritzhome" ];

  meta = {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    mainProgram = "fritzhome";
    homepage = "https://github.com/hthiery/python-fritzhome";
    changelog = "https://github.com/hthiery/python-fritzhome/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
