{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, voluptuous, aiohttp, async-timeout, python-didl-lite, defusedxml
, pytest_6, pytest-asyncio }:

buildPythonPackage rec {
  pname = "async-upnp-client";
  version = "0.14.15";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "async_upnp_client";
    rev = version;
    sha256 = "1mr65msdc51wq7326z3q41x79yi9dsmcjrmyzkgj9h9vgpxdk2nw";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    defusedxml
    python-didl-lite
    voluptuous
  ];

  checkInputs = [
    pytest_6
    pytest-asyncio
  ];

  meta = with lib; {
    description = "Asyncio UPnP Client library for Python/asyncio.";
    homepage = "https://github.com/StevenLooman/async_upnp_client";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
