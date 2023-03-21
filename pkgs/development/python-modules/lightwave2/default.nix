{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lightwave2";
  version = "0.8.21";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zgsgt78ll/5NVSca4lnxXYkiw5FE2WgcO10o/IZaHgQ=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lightwave2"
  ];

  meta = with lib; {
    description = "Library to interact with LightWaveRF 2nd Gen lights and switches";
    homepage = "https://github.com/bigbadblunt/lightwave2";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
