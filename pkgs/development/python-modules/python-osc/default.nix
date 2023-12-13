{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "python-osc";
  version = "1.8.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pc4bpWyNgt9Ryz8pRrXdM6cFInkazEuFZOYtKyCtnKo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pythonosc"
  ];

  meta = with lib; {
    description = "Open Sound Control server and client in pure python";
    homepage = "https://github.com/attwad/python-osc";
    changelog = "https://github.com/attwad/python-osc/blob/v${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ anirrudh ];
  };
}
