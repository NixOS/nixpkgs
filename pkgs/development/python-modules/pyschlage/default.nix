{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycognito,
  pytestCheckHook,
  pytest-timeout,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyschlage";
  version = "2026.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pyschlage";
    tag = version;
    hash = "sha256-P5YH3v03vWHRkVeOkrfMU/Xy5hPG2sk116/fVZVmsqU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pycognito
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ];

  pythonImportsCheck = [ "pyschlage" ];

  meta = {
    description = "Library for interacting with Schlage Encode WiFi locks";
    homepage = "https://github.com/dknowles2/pyschlage";
    changelog = "https://github.com/dknowles2/pyschlage/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
