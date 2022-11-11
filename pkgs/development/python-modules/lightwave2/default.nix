{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lightwave2";
  version = "0.8.16";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9hWkRY71Ab2J2oQSnGu/rb0KmV3+cJb7vY2sAexDGzU=";
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
