{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytado";
  version = "0.17.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = "refs/tags/${version}";
    hash = "sha256-FjdqZc4Zt2sLYJpnD/MAzr8Y9lGHteHB5psQqheS84I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "PyTado"
  ];

  meta = with lib; {
    description = "Python binding for Tado web API";
    mainProgram = "pytado";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
