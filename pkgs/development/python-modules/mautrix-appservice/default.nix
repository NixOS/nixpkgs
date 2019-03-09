{ lib, buildPythonPackage, fetchPypi, aiohttp, future-fstrings, pythonOlder }:

buildPythonPackage rec {
  pname = "mautrix-appservice";
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5752c6d84bf952698aec500b16542f6d2aacea37efd5be59087b5d9ea38c98f";
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
