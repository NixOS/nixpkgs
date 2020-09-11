{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, voluptuous, aiohttp, async-timeout, python-didl-lite, defusedxml
, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "async-upnp-client";
  version = "0.14.14";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "async_upnp_client";
    rev = version;
    sha256 = "1ysj72l4z78h427ar95x7af0jw0xq1cbca0k8b34vqyyhgs8wc6y";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    defusedxml
    python-didl-lite
    voluptuous
  ];

  checkInputs = [
    pytest
    pytest-asyncio
  ];

  meta = with lib; {
    description = "Asyncio UPnP Client library for Python/asyncio.";
    homepage = "https://github.com/StevenLooman/async_upnp_client";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
