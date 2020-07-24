{ lib, buildPythonPackage, fetchPypi, isPy3k, slixmpp, async-timeout, aiohttp }:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11mv52dwyccza09nbh2l7r9l3k06c5rzml3zinqbyznfxg3gaxi0";
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
