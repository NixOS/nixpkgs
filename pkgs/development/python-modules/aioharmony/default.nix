{ lib, buildPythonPackage, fetchPypi, isPy3k, slixmpp, async-timeout, aiohttp }:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "445323810978454ba3b32be53ba6b43cf9948586de3f9734b8743b55858b3cc7";
  };

  disabled = !isPy3k;

  #aioharmony does not seem to include tests
  doCheck = false;

  pythonImportsCheck = [ "aioharmony.harmonyapi" "aioharmony.harmonyclient" ];

  propagatedBuildInputs = [ slixmpp async-timeout aiohttp ];

  meta = with lib; {
    homepage = "https://github.com/ehendrix23/aioharmony";
    description =
      "Asyncio Python library for connecting to and controlling the Logitech Harmony";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
