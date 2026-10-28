{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  lxml,
  nvdlib,
  openai,
  poetry-core,
  pydantic,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "avidtools";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sx+g3yBJ478C8L2IhO1iYIzubsP6kTA2sCts3nwF23E=";
  };

  pythonRelaxDeps = [
    "lxml"
    "openai"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    beautifulsoup4
    lxml
    nvdlib
    openai
    pydantic
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "avidtools" ];

  meta = {
    description = "Developer tools for AVID";
    homepage = "https://github.com/avidml/avidtools";
    changelog = "https://github.com/avidml/avidtools/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
