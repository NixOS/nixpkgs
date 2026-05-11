{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  fastavro,
  httpx,
  pydantic,
  pydantic-core,
  requests,
  tokenizers,
  types-requests,
  typing-extensions,

  # optional-dependencies
  aiohttp,
  httpx-aiohttp,
  oci,
}:

buildPythonPackage rec {
  pname = "cohere";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cohere-ai";
    repo = "cohere-python";
    tag = version;
    hash = "sha256-be6vhTGXnf1/iaD13VYjey/to+HX28VfmYlUPE2eFT4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    fastavro
    httpx
    pydantic
    pydantic-core
    requests
    tokenizers
    types-requests
    typing-extensions
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      httpx-aiohttp
    ];
    oci = [ oci ];
  };

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
