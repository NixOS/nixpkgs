{ lib
, buildPythonPackage
, fetchPypi
, ifaddr
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pywilight";
  version = "0.0.74";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-patCdQ7qLEfy+RpH9T/Fa8ubI7QF6OmLzFUokZc5syQ=";
  };

  propagatedBuildInputs = [
    ifaddr
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pywilight"
  ];

  meta = with lib; {
    description = "Python API for WiLight device";
    homepage = "https://github.com/leofig-rj/pywilight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
