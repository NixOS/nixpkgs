{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "goveelights";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4j4iBT4PIpk6BbHwJF7+sp/PeIlHw+8dsOK1Ecfuwtc=";
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
