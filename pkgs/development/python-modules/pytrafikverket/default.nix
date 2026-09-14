{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  aiozoneinfo,
  lxml,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pytrafikverket";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iSHRqQ4spfyXHepYVJ6dcC5fH7Aw2YlKFAnip3V8gNQ=";
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

  meta = {
    description = "Library to get data from the Swedish Transport Administration (Trafikverket) API";
    homepage = "https://github.com/gjohansson-ST/pytrafikverket";
    changelog = "https://github.com/gjohansson-ST/pytrafikverket/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
