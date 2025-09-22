{
  lib,
  buildPythonPackage,
  ciso8601,
  fetchPypi,
  geopy,
  pythonOlder,
  requests,
  sseclient,
}:

buildPythonPackage rec {
  pname = "ritassist";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1JCKWb+3mdQYnL250Ml+kFkx6VAlBC7FL6XcQlQ+kC4=";
  };

  propagatedBuildInputs = [
    ciso8601
    geopy
    requests
    sseclient
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ritassist" ];

  meta = with lib; {
    description = "Python client to access RitAssist and FleetGO API";
    homepage = "https://github.com/depl0y/ritassist-py";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
