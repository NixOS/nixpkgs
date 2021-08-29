{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, isPy3k
, slixmpp
}:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.7";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aej8xC0Bsy6ip7IwO6onp55p6afkz8yZnz14cCExSPA=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    slixmpp
  ];

  # aioharmony does not seem to include tests
  doCheck = false;

  pythonImportsCheck = [ "aioharmony.harmonyapi" "aioharmony.harmonyclient" ];

  meta = with lib; {
    homepage = "https://github.com/ehendrix23/aioharmony";
    description = "Python library for interacting the Logitech Harmony devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ oro ];
  };
}
