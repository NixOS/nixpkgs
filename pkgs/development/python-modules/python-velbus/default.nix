{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-velbus";
  version = "2.1.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X0jg1qd4rWbaRZqgMBJKOZD50sFq3Eyhw9RU6cEjORo=";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # Project has not tests
  doCheck = false;

  pythonImportsCheck = [
    "velbus"
  ];

  meta = with lib; {
    description = "Python library to control the Velbus home automation system";
    homepage = "https://github.com/thomasdelaet/python-velbus";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
