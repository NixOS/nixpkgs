{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, voluptuous
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hatasmota";
  version = "0.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-fE5klk4ToayRyUmE2xtcMMsH4VKOKZHqvBCa9GG84rU=";
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
