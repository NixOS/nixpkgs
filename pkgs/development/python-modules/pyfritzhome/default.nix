{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "pyfritzhome";
  version = "0.6.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    rev = "refs/tags/${version}";
    hash = "sha256-jdv49cpd2ewfrhWzjWM5Uxhaj3UZfOXMMOZeobpXe0E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyfritzhome"
  ];

  meta = with lib; {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    homepage = "https://github.com/hthiery/python-fritzhome";
    changelog = "https://github.com/hthiery/python-fritzhome/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
