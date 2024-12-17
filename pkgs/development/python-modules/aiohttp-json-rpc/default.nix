{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiohttp-json-rpc";
  version = "0.13.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YjehBEeMIsbvlsciegHWgyWXtBTkt5pS2FWTNWoWnpk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [ "aiohttp_json_rpc" ];

  meta = with lib; {
    description = "Implementation JSON-RPC 2.0 server and client using aiohttp on top of websockets transport";
    homepage = "https://pypi.org/project/aiohttp-json-rpc/";
    license = licenses.asl20;
    maintainers = with maintainers; [ laggron42 ];
  };
}
