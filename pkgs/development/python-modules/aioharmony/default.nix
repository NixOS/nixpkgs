{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
, slixmpp
}:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.8";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0adf08955810a227db489556dc3ca808e4f825a00183f613797856114c2a2a47";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    slixmpp
  ];

  # aioharmony does not seem to include tests
  doCheck = false;

  pythonImportsCheck = [
    "aioharmony.harmonyapi"
    "aioharmony.harmonyclient"
  ];

  meta = with lib; {
    homepage = "https://github.com/ehendrix23/aioharmony";
    description = "Python library for interacting the Logitech Harmony devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
