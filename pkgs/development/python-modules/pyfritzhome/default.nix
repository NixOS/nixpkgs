{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyfritzhome";
  version = "0.6.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    rev = "refs/tags/${version}";
    hash = "sha256-MIWRBwqVuS1iEuWxsE1yuGS2zHYVgnH2G4JJk7Yct6s=";
  };

  propagatedBuildInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
