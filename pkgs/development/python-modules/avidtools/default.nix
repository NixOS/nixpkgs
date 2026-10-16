{
  lib,
  buildPythonPackage,
  fetchPypi,
  nvdlib,
  poetry-core,
  pydantic,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "avidtools";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sx+g3yBJ478C8L2IhO1iYIzubsP6kTA2sCts3nwF23E=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    nvdlib
    pydantic
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "avidtools" ];

  meta = {
    description = "Developer tools for AVID";
    homepage = "https://github.com/avidml/avidtools";
    changelog = "https://github.com/avidml/avidtools/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
