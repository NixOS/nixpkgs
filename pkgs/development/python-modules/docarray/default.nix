{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  numpy,
  orjson,
  pydantic,
  rich,
  types-requests,
  typing-inspect,
  # Optional dependencies
  av,
  elasticsearch,
  elastic-transport,
  fastapi,
  hnswlib,
  jax,
  lz4,
  jaxlib,
  pandas,
  pillow,
  types-pillow,
  protobuf,
  pydub,
  pyepsilla,
  pymilvus,
  qdrant-client,
  redis,
  smart-open,
  torch,
  trimesh,
  weaviate-client,
  # Test
  pytestCheckHook,
  mktestdocs,
  boto3,
  botocore,
  scipy,
}:
buildPythonPackage rec {
  pname = "docarray";
  version = "0.40.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "docarray";
    repo = "docarray";
    rev = "v${version}";
    hash = "sha256-Vqmfn36UYb3s5Y1OtxtHgU5bCJaWKb5Perqr6X3A9xA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    orjson
    pydantic
    rich
    types-requests
    typing-inspect
  ];

  optional-dependencies = {
    proto = [
      protobuf
      lz4
    ];
    pandas = [ pandas ];
    image = [
      pillow
      types-pillow
    ];
    video = [ av ];
    audio = [ pydub ];
    mesh = [ trimesh ];
    hnswlib = [
      hnswlib
      protobuf
    ];
    elasticsearch = [
      elasticsearch
      elastic-transport
    ];
    jac = [
      # jina-hubble-sdk
    ];
    aws = [ smart-open ];
    torch = [ torch ];
    web = [ fastapi ];
    qdrant = [ qdrant-client ];
    weaviate = [ weaviate-client ];
    milvus = [ pymilvus ];
    redis = [ redis ];
    jax = [
      jaxlib
      jax
    ];
    epsilla = [
      pyepsilla
    ];
  };

  pythonImportsCheck = [ "docarray" ];
  nativeCheckInputs = [
    pytestCheckHook
    boto3
    botocore
    elasticsearch
    elastic-transport
    fastapi
    hnswlib
    mktestdocs
    protobuf
    pyepsilla
    pymilvus
    qdrant-client
    scipy
    smart-open
    torch
    weaviate-client
  ];

  meta = with lib; {
    description = "Library expertly crafted for the representation, transmission, storage, and retrieval of multimodal data";
    homepage = "https://docs.docarray.org/";
    changelog = "https://github.com/docarray/docarray/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ loicreynier ];
  };
}
