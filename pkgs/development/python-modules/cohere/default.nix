{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  boto3,
  fastavro,
  httpx,
  httpx-sse,
  parameterized,
  pydantic,
  pydantic-core,
  requests,
  sagemaker,
  tokenizers,
  types-requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cohere";
  version = "5.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cohere-ai";
    repo = "cohere-python";
    rev = "refs/tags/${version}";
    hash = "sha256-KhONCdIGKYbIcFG+zv6uXSiX+crsmgPZUU+5NsSWaA8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    fastavro
    httpx
    httpx-sse
    parameterized
    pydantic
    pydantic-core
    requests
    sagemaker
    tokenizers
    types-requests
    typing-extensions
  ];

  # tests require CO_API_KEY
  doCheck = false;

  pythonImportsCheck = [ "cohere" ];

  meta = {
    description = "Simplify interfacing with the Cohere API";
    homepage = "https://docs.cohere.com/docs";
    changelog = "https://github.com/cohere-ai/cohere-python/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
