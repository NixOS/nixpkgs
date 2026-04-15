{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  aiohttp,
  aiohttp-sse-client,
  charset-normalizer,
  dataclasses-json,
  oauth2-client,
}:

buildPythonPackage rec {
  pname = "home-connect-async";
  version = "0.8.5";
  pyproject = true;

  src = fetchPypi {
    pname = "home_connect_async";
    inherit version;
    hash = "sha256-LiBBE9AiyMWipQKtHsOZ5rfqOgB75flrJYtU1oAw+hs=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    aiohttp-sse-client
    charset-normalizer
    dataclasses-json
    oauth2-client
  ];

  pythonImportsCheck = [
    "home_connect_async"
  ];

  meta = {
    description = "Async SDK for BSH Home Connect API";
    homepage = "https://pypi.org/project/home-connect-async";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
