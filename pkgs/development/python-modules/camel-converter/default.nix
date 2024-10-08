{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "camel-converter";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "sanders41";
    repo = "camel-converter";
    rev = "refs/tags/v${version}";
    hash = "sha256-JdONlMTBnZ2QMcsr+GXmfQzxaFOndmG77qbBa9A3m+k=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ] ++ optional-dependencies.pydantic;

  pythonImportsCheck = [ "camel_converter" ];

  disabledTests = [
    # AttributeError: 'Test' object has no attribute 'model_dump'
    "test_camel_config"
  ];

  meta = with lib; {
    description = "Module to convert strings from snake case to camel case or camel case to snake case";
    homepage = "https://github.com/sanders41/camel-converter";
    changelog = "https://github.com/sanders41/camel-converter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
