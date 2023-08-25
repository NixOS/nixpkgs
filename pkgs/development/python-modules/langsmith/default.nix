{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "langsmith";
  version = "0.0.24";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langsmith-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uv6zzSWs+Fvb0ztwgkbkZcaNJOFpt8pWh88HZHsTris=";
  };

  sourceRoot = "${src.name}/python";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pydantic
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # These tests require network access
    "integration_tests"
  ];

  pythonImportsCheck = [
    "langsmith"
  ];

  meta = with lib; {
    description = "Client library to connect to the LangSmith LLM Tracing and Evaluation Platform";
    homepage = "https://github.com/langchain-ai/langsmith-sdk";
    changelog = "https://github.com/langchain-ai/langsmith-sdk/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
