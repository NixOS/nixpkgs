{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pydantic,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "json-repair";
  version = "0.63.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VRRtL8X9egdqdz6Celw1CGGTuWd9YMVbq/uHwHtmv64=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    schema = [
      jsonschema
      pydantic
    ];
  };

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
