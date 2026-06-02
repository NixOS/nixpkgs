{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycognito,
  pytestCheckHook,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyschlage";
  version = "2026.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pyschlage";
    tag = version;
    hash = "sha256-N4eL+SJleCEn9wk7Tk4/K1Unt8hfvsIG1Votn4eYUd4=";
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

  meta = {
    description = "Library for interacting with Schlage Encode WiFi locks";
    homepage = "https://github.com/dknowles2/pyschlage";
    changelog = "https://github.com/dknowles2/pyschlage/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
