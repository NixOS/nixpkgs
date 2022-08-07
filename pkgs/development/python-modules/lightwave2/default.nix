{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lightwave2";
  version = "0.8.15";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FKEUpfHnPwiLwC8fk+6AikviZKX7DBoWpSMxK1cHC2Y=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lightwave2"
  ];

  meta = with lib; {
    description = "Python library to interact with LightWaveRF 2nd Gen lights and switches";
    homepage = "https://github.com/bigbadblunt/lightwave2";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
