{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-velbus";
  version = "2.1.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3eDfXPMO167QI/umLBjlHTBV67XQ8QYkg4EzfrRTw6M=";
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
