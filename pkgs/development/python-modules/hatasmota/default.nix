{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, voluptuous
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hatasmota";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-8B3xdSvvxmbjpPk6aWHQTraf2J1oCBvP0/UxTxaN0jY=";
  };

  propagatedBuildInputs = [
    attrs
    voluptuous
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hatasmota"
  ];

  meta = with lib; {
    description = "Python module to help parse and construct Tasmota MQTT messages";
    homepage = "https://github.com/emontnemery/hatasmota";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
