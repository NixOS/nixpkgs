{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  aiohttp,
  argparse,
  grpcio,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-grpc,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-instrumentation-requests,
  opentelemetry-instrumentation-sqlalchemy,
  opentelemetry-instrumentation-threading,
  opentelemetry-instrumentation-urllib3,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions-ai,
  pydantic,
  python-dotenv,
  requests,
  tenacity,
  tqdm,
  # opentelemetry-instrumentation-alephalpha,
  # opentelemetry-instrumentation-anthropic,
  # opentelemetry-instrumentation-bedrock,
  # opentelemetry-instrumentation-chromadb,
  # opentelemetry-instrumentation-cohere,
  # opentelemetry-instrumentation-google-generativeai,
  # opentelemetry-instrumentation-groq,
  # opentelemetry-instrumentation-haystack,
  # opentelemetry-instrumentation-lancedb,
  # opentelemetry-instrumentation-langchain,
  # opentelemetry-instrumentation-llamaindex,
  # opentelemetry-instrumentation-marqo,
  # opentelemetry-instrumentation-milvus,
  # opentelemetry-instrumentation-mistralai,
  # opentelemetry-instrumentation-ollama,
  # opentelemetry-instrumentation-openai,
  # opentelemetry-instrumentation-pinecone,
  # opentelemetry-instrumentation-qdrant,
  # opentelemetry-instrumentation-replicate,
  # opentelemetry-instrumentation-sagemaker,
  # opentelemetry-instrumentation-together,
  # opentelemetry-instrumentation-transformers,
  # opentelemetry-instrumentation-vertexai,
  # opentelemetry-instrumentation-watsonx,
  # opentelemetry-instrumentation-weaviate,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lmnr";
  version = "0.4.60";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CcFjyEaWO+4P+HnFP0iWfE5nOlmDuJQ8xulFsE23B/Y=";
  };

  build-system = [ poetry-core ];

  # there is no need to pin grpcio, see the upstream comment
  # https://github.com/lmnr-ai/lmnr-python/blob/bbf5d9c83fb1dbc96adb9e09be5f7326c8c93c65/pyproject.toml#L34-L35
  # > explicitly freeze grpcio. Since 1.68.0, grpcio writes a warning message
  # > that looks scary, but is harmless.
  pythonRelaxDeps = [ "grpcio" ];

  pythonRemoveDeps = [ "argparse" ];

  dependencies = [
    aiohttp
    grpcio
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation-requests
    opentelemetry-instrumentation-sqlalchemy
    opentelemetry-instrumentation-threading
    opentelemetry-instrumentation-urllib3
    opentelemetry-sdk
    opentelemetry-semantic-conventions-ai
    pydantic
    python-dotenv
    requests
    tenacity
    tqdm
  ];

  optional-dependencies = {
    # alephalpha = [ opentelemetry-instrumentation-alephalpha ];
    all = [
      # opentelemetry-instrumentation-alephalpha
      # opentelemetry-instrumentation-anthropic
      # opentelemetry-instrumentation-bedrock
      # opentelemetry-instrumentation-chromadb
      # opentelemetry-instrumentation-cohere
      # opentelemetry-instrumentation-google-generativeai
      # opentelemetry-instrumentation-groq
      # opentelemetry-instrumentation-haystack
      # opentelemetry-instrumentation-lancedb
      # opentelemetry-instrumentation-langchain
      # opentelemetry-instrumentation-llamaindex
      # opentelemetry-instrumentation-marqo
      # opentelemetry-instrumentation-milvus
      # opentelemetry-instrumentation-mistralai
      # opentelemetry-instrumentation-ollama
      # opentelemetry-instrumentation-openai
      # opentelemetry-instrumentation-pinecone
      # opentelemetry-instrumentation-qdrant
      # opentelemetry-instrumentation-replicate
      # opentelemetry-instrumentation-sagemaker
      # opentelemetry-instrumentation-together
      # opentelemetry-instrumentation-transformers
      # opentelemetry-instrumentation-vertexai
      # opentelemetry-instrumentation-watsonx
      # opentelemetry-instrumentation-weaviate
    ];
    # anthropic = [ opentelemetry-instrumentation-anthropic ];
    # bedrock = [ opentelemetry-instrumentation-bedrock ];
    # chromadb = [ opentelemetry-instrumentation-chromadb ];
    # cohere = [ opentelemetry-instrumentation-cohere ];
    # google-generativeai = [ opentelemetry-instrumentation-google-generativeai ];
    # groq = [ opentelemetry-instrumentation-groq ];
    # haystack = [ opentelemetry-instrumentation-haystack ];
    # lancedb = [ opentelemetry-instrumentation-lancedb ];
    # langchain = [ opentelemetry-instrumentation-langchain ];
    # llamaindex = [ opentelemetry-instrumentation-llamaindex ];
    # marqo = [ opentelemetry-instrumentation-marqo ];
    # milvus = [ opentelemetry-instrumentation-milvus ];
    # mistralai = [ opentelemetry-instrumentation-mistralai ];
    # ollama = [ opentelemetry-instrumentation-ollama ];
    # openai = [ opentelemetry-instrumentation-openai ];
    # pinecone = [ opentelemetry-instrumentation-pinecone ];
    # qdrant = [ opentelemetry-instrumentation-qdrant ];
    # replicate = [ opentelemetry-instrumentation-replicate ];
    # sagemaker = [ opentelemetry-instrumentation-sagemaker ];
    # together = [ opentelemetry-instrumentation-together ];
    # transformers = [ opentelemetry-instrumentation-transformers ];
    # vertexai = [ opentelemetry-instrumentation-vertexai ];
    # watsonx = [ opentelemetry-instrumentation-watsonx ];
    # weaviate = [ opentelemetry-instrumentation-weaviate ];
  };

  pythonImportsCheck = [ "lmnr" ];

  # pypi tarball has no tests
  doCheck = false;

  meta = {
    description = "Python SDK for Laminar";
    homepage = "https://github.com/lmnr-ai/lmnr-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
