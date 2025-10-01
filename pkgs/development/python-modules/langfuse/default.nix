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
  opentelemetry-api,
  opentelemetry-sdk,
  opentelemetry-exporter-otlp,
  packaging,
  poetry-core,
  pydantic,
  requests,
  wrapt,
}:

buildPythonPackage rec {
  pname = "langfuse";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langfuse";
    repo = "langfuse-python";
    tag = "v${version}";
    hash = "sha256-1qRdx2j5M6eIIzsHeNgGagqhvCb7WBNAmdVeie6bHI4=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = [
    anyio
    backoff
    httpx
    idna
    opentelemetry-api
    opentelemetry-sdk
    opentelemetry-exporter-otlp
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
