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
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "ogmios";
    inherit version;
    hash = "sha256-L+BBuWhcQhnE9f+b860401WKTUcFxf7Ehji1MHCNqjo=";
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
    maintainers = with maintainers; [ aciceri ];
  };
}
