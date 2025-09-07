{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  asyncio-dgram,
  xmltodict,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-rako-2025";
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonleigh";
    repo = "python-rako";
    rev = "8f85242ca829c158ea5f6496bc457d3c0a4f4b3f";
    hash = "sha256-MdXNbC0jWXBz8XEQXZ1QMbjSW51wXF40IgMkkAPsj+M=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    asyncio-dgram
    xmltodict
  ];

  pythonImportsCheck = [ "python_rako" ];

  meta = with lib; {
    description = "Asynchronous Python client for Rako Controls Lighting";
    homepage = "https://github.com/simonleigh/python-rako";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}