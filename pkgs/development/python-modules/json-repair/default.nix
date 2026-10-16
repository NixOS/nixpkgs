{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  setuptools,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "json-repair";
  version = "0.63.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hqVSZoTqhMEQhymhX+prUYWOXogEJ0XPK7r5DdPwg44=";
  };

  build-system = [ setuptools ];

  optional-dependencies.schema = [
    jsonschema
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # Disable benchmark tests
    "tests/test_performance.py"
  ];

  pythonImportsCheck = [ "json_repair" ];

  meta = {
    description = "Module to repair invalid JSON, commonly used to parse the output of LLMs";
    homepage = "https://github.com/mangiucugna/json_repair/";
    changelog = "https://github.com/mangiucugna/json_repair/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
    mainProgram = "json_repair";
  };
})
