{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "camel-converter";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanders41";
    repo = "camel-converter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZBZY6uIYbB7mIGyhyEW5H1ZgaqpjRJ+wkd+QOSsAFuc=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "camel_converter" ];

  disabledTests = [
    # AttributeError: 'Test' object has no attribute 'model_dump'
    "test_camel_config"
  ];

  meta = {
    description = "Module to convert strings from snake case to camel case or camel case to snake case";
    homepage = "https://github.com/sanders41/camel-converter";
    changelog = "https://github.com/sanders41/camel-converter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
