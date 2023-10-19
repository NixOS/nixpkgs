{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, voluptuous
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hatasmota";
  version = "0.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lsb92JsqIhq7zaNaolgV8dtSFIq+Enklb6hlBvT7/Ig=";
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
    changelog = "https://github.com/emontnemery/hatasmota/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
