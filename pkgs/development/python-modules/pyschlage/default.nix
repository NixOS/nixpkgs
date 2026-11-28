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
  version = "2026.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pyschlage";
    tag = version;
    hash = "sha256-9AqFVK8hwHG4Wkyob1C/MAEkpyzshlFDxIRzk7t7bDw=";
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
