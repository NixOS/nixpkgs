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
<<<<<<< HEAD
  version = "1.4.3";
=======
  version = "1.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "ogmios";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-+edW34O+OF+JyCoZSjxRwKS6JeXfaZ38+ykUpXwBJ1Q=";
=======
    hash = "sha256-L+BBuWhcQhnE9f+b860401WKTUcFxf7Ehji1MHCNqjo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python client for Ogmios";
    homepage = "https://gitlab.com/viperscience/ogmios-python";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aciceri ];
=======
  meta = with lib; {
    description = "Python client for Ogmios";
    homepage = "https://gitlab.com/viperscience/ogmios-python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aciceri ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
