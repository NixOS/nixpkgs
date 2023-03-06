{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-velbus";
  version = "2.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SbuECT6851E+QNyyPaNTnKmH54fYovemSto8gvfMIKg=";
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
