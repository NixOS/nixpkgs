{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  aiozoneinfo,
  lxml,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pytrafikverket";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qvJbAE5C19RSg5p823sCJ/dWIHBSD4kJrw/p8PF2HkI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiozoneinfo
    lxml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pytrafikverket" ];

  meta = with lib; {
    description = "Library to get data from the Swedish Transport Administration (Trafikverket) API";
    homepage = "https://github.com/gjohansson-ST/pytrafikverket";
    changelog = "https://github.com/gjohansson-ST/pytrafikverket/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
