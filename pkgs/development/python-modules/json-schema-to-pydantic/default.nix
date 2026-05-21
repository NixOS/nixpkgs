{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "json-schema-to-pydantic";
  version = "0.4.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "richard-gyiko";
    repo = "json-schema-to-pydantic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9T7ScIf5jJBbldNwLHEchrctr3V4LmqxNGhor6QIzO4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json_schema_to_pydantic" ];

  meta = {
    description = "Generates Pydantic v2 models from JSON Schema definitions";
    homepage = "https://github.com/richard-gyiko/json-schema-to-pydantic";
    changelog = "https://github.com/richard-gyiko/json-schema-to-pydantic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aos ];
  };
})
