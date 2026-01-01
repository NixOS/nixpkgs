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
<<<<<<< HEAD
  version = "3.11.0";
=======
  version = "3.8.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langfuse";
    repo = "langfuse-python";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3hL29Gu1lonkWAOyTqH2q03joXwVQimbVF0R2nYZUIs=";
=======
    hash = "sha256-HXg7p3yfRXK13FLxkfCaKxZxDkXX8Y274ZVKL17Zj0A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
