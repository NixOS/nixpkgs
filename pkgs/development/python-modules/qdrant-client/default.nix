{
  lib,
  buildPythonPackage,
  fastembed,
  fetchFromGitHub,
  grpcio,
  grpcio-tools,
  httpx,
  numpy,
  poetry-core,
  portalocker,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "qdrant-client";
  version = "1.17.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-client";
    tag = "v${version}";
    hash = "sha256-HGBvd8sjs52qiVf7VJupH7qcGnr3N/n2WP8kM1crvIY=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "portalocker"
  ];

  dependencies = [
    grpcio
    grpcio-tools
    httpx
    numpy
    portalocker
    pydantic
    urllib3
  ]
  ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [ "qdrant_client" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # Tests require network access
  doCheck = false;

  optional-dependencies = {
    fastembed = [ fastembed ];
  };

  meta = {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
