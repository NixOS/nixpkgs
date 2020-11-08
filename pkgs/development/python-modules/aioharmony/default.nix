{ lib, buildPythonPackage, fetchPypi, isPy3k, slixmpp, async-timeout, aiohttp }:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90f4d1220d44b48b21a57e0273aa3c4a51599d0097af88e8be26df151e599344";
  };

  disabled = !isPy3k;

  #aioharmony does not seem to include tests
  doCheck = false;

  pythonImportsCheck = [ "aioharmony.harmonyapi" "aioharmony.harmonyclient" ];

  requiredPythonModules = [ slixmpp async-timeout aiohttp ];

  meta = with lib; {
    homepage = "https://github.com/ehendrix23/aioharmony";
    description =
      "Asyncio Python library for connecting to and controlling the Logitech Harmony";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
