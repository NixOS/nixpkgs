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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  urllib3,
}:

buildPythonPackage rec {
  pname = "qdrant-client";
<<<<<<< HEAD
  version = "1.16.2";
  pyproject = true;

=======
  version = "1.16.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant-client";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-sOZDQmwiTz3lZ1lR0xJDxMmNc5QauWLJV5Ida2INibY=";
=======
    hash = "sha256-YRBSSYF+XnPkpc3WjCrSxsJ27CsgEY8GWqSbaT4p6Sw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
=======
  meta = with lib; {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
