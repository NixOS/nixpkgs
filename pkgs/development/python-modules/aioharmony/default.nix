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
  version = "0.2.9";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T30pLzPWD+5pb0ShkpNdiBFO45RdiMYgCOSg8rx+t+Y=";
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
