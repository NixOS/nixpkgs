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
  version = "1.11.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-NIGmQMtGvm6zifYJIMFx+d9w9IZmQUAqieBo/3JmYbM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    grpcio
    grpcio-tools
    httpx
    numpy
    portalocker
    pydantic
    urllib3
  ] ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [ "qdrant_client" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # Tests require network access
  doCheck = false;

  passthru.optional-dependencies = {
    fastembed = [ fastembed ];
  };

  meta = with lib; {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
