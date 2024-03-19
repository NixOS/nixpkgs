{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "goveelights";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A7tfY+aFzhfruCZ43usj1/CsTejbPMzHM8SYrY/TU1s=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "goveelights"
  ];

  meta = with lib; {
    description = "Python module for interacting with the Govee API";
    homepage = "https://github.com/arcanearronax/govee_lights";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
