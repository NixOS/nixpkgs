{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  anyio,
  backoff,
  httpx,
  idna,
  langchain,
  llama-index,
  openai,
  packaging,
  poetry-core,
  pydantic,
  requests,
  wrapt,
}:

buildPythonPackage rec {
  pname = "langfuse";
  version = "2.60.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langfuse";
    repo = "langfuse-python";
    tag = "v${version}";
    hash = "sha256-ipiEd03X2uyxHlcwAGL55NmF0dle4/be96MQsSt/Vvg=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = [
    anyio
    backoff
    httpx
    idna
    packaging
    pydantic
    requests
    wrapt
  ];

  optional-dependencies = {
    langchain = [ langchain ];
    llama-index = [ llama-index ];
    openai = [ openai ];
  };

  pythonImportsCheck = [ "langfuse" ];

  # tests require network access and openai api key
  doCheck = false;

  meta = {
    description = "Instrument your LLM app with decorators or low-level SDK and get detailed tracing/observability";
    homepage = "https://github.com/langfuse/langfuse-python";
    changelog = "https://github.com/langfuse/langfuse-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
