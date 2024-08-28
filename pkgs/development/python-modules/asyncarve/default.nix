{
  lib,
  buildPythonPackage,
  fetchPypi,
  mashumaro,
  orjson,
  aiohttp,
  yarl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncarve";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5h56Sr0kPLrNPU70W90WsjmWax/N90dRMJ6lI5Mg86E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mashumaro
    orjson
    aiohttp
    yarl
  ];

  # No tests in repo
  doCheck = false;

  pythonImportsCheck = [ "asyncarve" ];

  meta = with lib; {
    description = "Simple Arve library";
    homepage = "https://github.com/arvetech/asyncarve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ pyrox0 ];
  };
}
