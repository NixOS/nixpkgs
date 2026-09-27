{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  requests,
  setuptools,
  websocket-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "dirigera";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Leggin";
    repo = "dirigera";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R8K32jTYIh6GW3WyGRUJWxwi7Elw0D0iX8flr422L5M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    requests
    websocket-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dirigera" ];

  meta = {
    description = "Module for controlling the IKEA Dirigera Smart Home Hub";
    homepage = "https://github.com/Leggin/dirigera";
    changelog = "https://github.com/Leggin/dirigera/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "generate-token";
  };
})
