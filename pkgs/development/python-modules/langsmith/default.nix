{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "langsmith";
  version = "0.0.57";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langsmith-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-3P0vB7wz/K3skejyPwtFZN17mFrOw9TGLHTJHvu4m7M=";
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
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # These tests require network access
    "integration_tests"
    # due to circular import
    "test_as_runnable"
    "test_as_runnable_batch"
    "test_as_runnable_async"
    "test_as_runnable_async_batch"
  ];

  disabledTestPaths = [
    # due to circular import
    "tests/integration_tests/test_client.py"
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
