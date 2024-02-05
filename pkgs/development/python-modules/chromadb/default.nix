{ buildPythonPackage
, lib
, pythonOlder
, fetchPypi
, setuptools
, setuptools-scm
, build
, requests
, pydantic
, chroma-hnswlib
, fastapi
, uvicorn
, numpy
, posthog
, pulsar
, onnxruntime
, opentelemetry-api
, opentelemetry-exporter-otlp-proto-grpc
, opentelemetry-instrumentation-fastapi
, opentelemetry-sdk
, tokenizers
, pypika
, tqdm
, overrides
, importlib-resources
, grpcio
, bcrypt
, typer
, kubernetes
, tenacity
, pyyaml
, mmh3
}:

buildPythonPackage rec {
  pname = "chromadb";
  version = "0.4.22";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x5MUnhwru7Utd2AsbAWUxXUvBM2b4SYZJQ3a0ggq8no=";
  };
  format = "pyproject";

  disabled = pythonOlder "3.9";

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    build
    requests
    pydantic
    chroma-hnswlib
    fastapi
    uvicorn
    numpy
    posthog
    pulsar
    onnxruntime
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-instrumentation-fastapi
    opentelemetry-sdk
    tokenizers
    pypika
    tqdm
    overrides
    importlib-resources
    grpcio
    bcrypt
    typer
    kubernetes
    tenacity
    pyyaml
    mmh3
  ];

  pythonImportsCheck = [
    "chromadb"
  ];

  meta = {
    changelog = "https://github.com/chroma-core/chroma/releases/tag/v${version}";
    description = "the AI-native open-source embedding database";
    homepage = "https://trychroma.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vonfry ];
    mainProgram = "chroma";
  };
}
