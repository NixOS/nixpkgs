{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytado";
  version = "0.17.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = "refs/tags/${version}";
    sha256 = "sha256-w1qtSEpnZCs7+M/0Gywz9AeMxUzz2csHKm9SxBKzmz4=";
  };

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
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
