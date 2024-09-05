{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boto3,
  langchain-core,
  numpy,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
  langchain-standard-tests,
}:

buildPythonPackage rec {
  pname = "langchain-aws";
  version = "0.1.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-aws";
    rev = "refs/tags/v${version}";
    hash = "sha256-n9nQheuUZMrjZMpR3aqbrRb/AhcgiF4CFO9ROh9aFNc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--snapshot-warn-unused" "" \
      --replace-fail "--cov=langchain_aws" ""
  '';

  sourceRoot = "${src.name}/libs/aws";

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    langchain-core
    numpy
  ];

  nativeCheckInputs = [
    langchain-standard-tests
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_aws" ];

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-aws/releases/tag/v${version}";
    description = "Build LangChain application on AWS";
    homepage = "https://github.com/langchain-ai/langchain-aws/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      natsukium
    ];
  };
}
