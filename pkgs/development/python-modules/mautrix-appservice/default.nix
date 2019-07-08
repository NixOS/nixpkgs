{ lib, buildPythonPackage, fetchPypi, aiohttp, future-fstrings, pythonOlder }:

buildPythonPackage rec {
  pname = "mautrix-appservice";
  version = "0.3.10.dev1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed827ff2a50b43f8125268145991d51b4a32ea4fbdd95b589ea15019b72a0bc3";
  };

  propagatedBuildInputs = [
    aiohttp
    future-fstrings
  ];

  # No tests available
  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with lib; {
    homepage = https://github.com/tulir/mautrix-appservice-python;
    description = "A Python 3 asyncio-based Matrix application service framework";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
