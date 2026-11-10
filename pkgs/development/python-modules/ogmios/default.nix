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
  version = "1.4.3";
  pyproject = true;

  src = fetchPypi {
    pname = "ogmios";
    inherit version;
    hash = "sha256-+edW34O+OF+JyCoZSjxRwKS6JeXfaZ38+ykUpXwBJ1Q=";
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

  meta = {
    description = "Python client for Ogmios";
    homepage = "https://gitlab.com/viperscience/ogmios-python";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aciceri ];
  };
}
