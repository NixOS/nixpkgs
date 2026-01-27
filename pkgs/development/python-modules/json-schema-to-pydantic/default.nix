{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  uv-dynamic-versioning,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-schema-to-pydantic";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "richard-gyiko";
    repo = "json-schema-to-pydantic";
    tag = "v${version}";
    hash = "sha256-jaXm5YOMA5zV5bhC/ZoGaR/7xIQEfTGQZ6mgVYnWJA4=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json_schema_to_pydantic" ];

  meta = {
    description = "A Python library for automatically generating Pydantic v2 models from JSON Schema definitions.";
    homepage = "https://github.com/richard-gyiko/json-schema-to-pydantic";
    changelog = "https://github.com/richard-gyiko/json-schema-to-pydantic/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aos ];
  };
}
