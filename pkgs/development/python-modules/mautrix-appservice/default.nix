{ lib, buildPythonPackage, fetchPypi, aiohttp, future-fstrings, pythonOlder }:

buildPythonPackage rec {
  pname = "mautrix-appservice";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1615220f5bb75e2093ad1e30f4c2e1243499b0b20caef014fd73faadd3bfea6c";
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
