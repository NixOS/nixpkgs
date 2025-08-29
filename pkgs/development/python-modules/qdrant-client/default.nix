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
  pythonOlder,
  urllib3,
}:

buildPythonPackage rec {
  pname = "qdrant-client";
  version = "1.15.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-client";
    tag = "v${version}";
    hash = "sha256-tZu6NeoStPwZ1f+AlVws8iS3UwpKikxE6Es7WKlFQfw=";
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

  meta = with lib; {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
