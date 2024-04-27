{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.17.5";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = "refs/tags/${version}";
    hash = "sha256-FjdqZc4Zt2sLYJpnD/MAzr8Y9lGHteHB5psQqheS84I=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python binding for Tado web API. Pythonize your central heating!";
    mainProgram = "pytado";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
