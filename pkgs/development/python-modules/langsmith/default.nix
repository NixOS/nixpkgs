{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, requests
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage {
  pname = "langsmith";
  version = "0.0.14";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchainplus-sdk";
    # there are no correct tags
    # https://github.com/langchain-ai/langchainplus-sdk/issues/105
    rev = "092f67222e4beabca0f51ba03f1ee028f916da63";
    hash = "sha256-U8fs16Uq80EB7Ey5YuQhUKKI9DOXJWlabM5JdoDnWP0=";
  };

  sourceRoot = "source/python";

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
    # these tests require network access
    "integration_tests"
  ];

  pythonImportsCheck = [ "langsmith" ];

  meta = with lib; {
    description = "Client library to connect to the LangSmith LLM Tracing and Evaluation Platform";
    homepage = "https://github.com/langchain-ai/langchainplus-sdk";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
