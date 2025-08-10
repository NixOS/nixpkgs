{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycognito,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyschlage";
  version = "2025.7.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pyschlage";
    tag = version;
    hash = "sha256-6IY+rCz/tMaj+c2ME8g9KzdYcakW2rcgM9DFHJSF3Jc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pycognito
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyschlage" ];

  meta = with lib; {
    description = "Library for interacting with Schlage Encode WiFi locks";
    homepage = "https://github.com/dknowles2/pyschlage";
    changelog = "https://github.com/dknowles2/pyschlage/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
