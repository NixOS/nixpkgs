{
  lib,
  buildPythonPackage,
  ciso8601,
  fetchPypi,
  geopy,
  requests,
  sseclient,
}:

buildPythonPackage rec {
  pname = "ritassist";
  version = "0.9.3";
  format = "setuptools";

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

  meta = {
    description = "Python client to access RitAssist and FleetGO API";
    homepage = "https://github.com/depl0y/ritassist-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
