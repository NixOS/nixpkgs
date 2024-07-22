{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  requests,
  tokenizers,
  types-requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cohere";
  version = "5.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cohere-ai";
    repo = "cohere-python";
    rev = "refs/tags/${version}";
    hash = "sha256-NnEjW4zDVaU87Sm1t7DM7QPbcpAf7X9MGkV346Bb4Xk=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    fastavro
    httpx
    httpx-sse
    parameterized
    pydantic
    requests
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
