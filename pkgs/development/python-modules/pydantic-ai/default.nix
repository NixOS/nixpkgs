{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic-ai-slim,
  pythonOlder,
  pytestCheckHook,
  pytest-vcr,
  dirty-equals,
}:

buildPythonPackage rec {
  pname = "pydantic-ai";
  version = "0.0.29";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${version}";
    hash = "sha256-UT2Nls4JRy2grefIn+1z2V/YxWnrl0uzzjIkpqyDGZM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pydantic-ai-slim
  ];

  nativeCheckInputs = [
    pydantic-ai-slim
    pytest-vcr
    dirty-equals
    # pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydantic_ai"
  ];

  meta = {
    description = "Agent Framework / shim to use Pydantic with LLMs";
    homepage = "https://github.com/pydantic/pydantic-ai";
    changelog = "https://github.com/pydantic/pydantic-ai/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yomaq ];
  };
}
