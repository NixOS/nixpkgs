{
  lib,
  buildPythonPackage,
  fetchPypi,
  paho-mqtt,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pyephember";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j3SftxXKs9EZwdio26W5U0y5owH4yTteS4RUmzkZkoE=";
  };

  propagatedBuildInputs = [
    paho-mqtt
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyephember" ];

  meta = with lib; {
    description = "Python client to the EPH Control Systems Ember API";
    homepage = "https://github.com/ttroy50/pyephember";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
