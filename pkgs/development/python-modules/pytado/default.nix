{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytado";
  version = "0.17.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = "refs/tags/${version}";
    sha256 = "sha256-Wdd9HdsQjaYlL8knhMuO87+dom+aTsmrLRK0UdrpsbQ=";
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
