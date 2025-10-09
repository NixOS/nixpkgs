{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  fastavro,
  httpx,
  httpx-sse,
  pydantic,
  pydantic-core,
  requests,
  tokenizers,
  types-requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cohere";
  version = "5.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cohere-ai";
    repo = "cohere-python";
    tag = version;
    hash = "sha256-p0EQZ7C5z9qi62L3KESF/oQf/yWKtnG1fzCAoSatuVU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    fastavro
    httpx
    httpx-sse
    pydantic
    pydantic-core
    requests
    tokenizers
    types-requests
    typing-extensions
  ];

  pythonRelaxDeps = [ "httpx-sse" ];

  # tests require CO_API_KEY
  doCheck = false;

  pythonImportsCheck = [ "cohere" ];

  meta = {
    description = "Simplify interfacing with the Cohere API";
    homepage = "https://docs.cohere.com/docs";
    changelog = "https://github.com/cohere-ai/cohere-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
