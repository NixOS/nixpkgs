{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
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

buildPythonPackage (finalAttrs: {
  pname = "langfuse";
  version = "3.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langfuse";
    repo = "langfuse-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CZa1nzgGHQSx/cPkOxbDsfkWpgr/veWRN8zgHeYrJOw=";
  };

  # https://github.com/langfuse/langfuse/issues/9618
  disabled = pythonAtLeast "3.14";

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
    changelog = "https://github.com/langfuse/langfuse-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
