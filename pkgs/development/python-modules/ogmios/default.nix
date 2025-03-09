{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  setuptools,
  # Python deps
  cachetools,
  cardano-tools,
  coloredlogs,
  orjson,
  pydantic,
  websockets,
}:

buildPythonPackage rec {
  pname = "ogmios";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ogmios";
    inherit version;
    hash = "sha256-b5L1J9lqHEQmlw7alv5HnpXM0gpE26cGkddEKH5cSU0=";
  };

  build-system = [
    hatchling
    setuptools
  ];

  dependencies = [
    cachetools
    cardano-tools
    coloredlogs
    orjson
    pydantic
    websockets
  ];

  pythonImportsCheck = [ "ogmios" ];

  meta = with lib; {
    description = "Python client for Ogmios";
    homepage = "https://gitlab.com/viperscience/ogmios-python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ t4ccer ];
  };
}
