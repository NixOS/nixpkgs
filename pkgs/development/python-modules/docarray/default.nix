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
  version = "0.40.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "docarray";
    repo = "docarray";
    rev = "v${version}";
    hash = "sha256-NwdH57I8CQ14ulArfYz/+doviIiOuBxxjXokeve0i5Q=";
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

  disabledTestPaths = [
    "tests/benchmark_tests/test_map.py"
    "tests/documentation/test_docstring.py"
    "tests/index/base_classes/test_base_doc_store.py"
    "tests/index/elastic/v7/test_subindex.py"
    "tests/index/elastic/v8/test_subindex.py"
    "tests/index/hnswlib/test_subindex.py"
    "tests/index/in_memory/test_persist_data.py"
    "tests/index/in_memory/test_subindex.py"
    "tests/index/milvus/test_subindex.py"
    "tests/index/mongo_atlas/test_query_builder.py"
    "tests/index/mongo_atlas/test_subindex.py"
    "tests/index/qdrant/test_subindex.py"
    "tests/index/redis/test_configurations.py"
    "tests/index/redis/test_find.py"
    "tests/index/redis/test_index_get_del.py"
    "tests/index/redis/test_persist_data.py"
    "tests/index/redis/test_subindex.py"
    "tests/index/weaviate/test_column_config_weaviate.py"
    "tests/index/weaviate/test_find_weaviate.py"
    "tests/index/weaviate/test_index_get_del_weaviate.py"
    "tests/index/weaviate/test_subindex.py"
    "tests/units/array/test_array_proto.py"
    "tests/units/document/proto/test_document_proto.py"
    "tests/units/document/test_from_to_bytes.py"
  ];

  meta = with lib; {
    description = "Library expertly crafted for the representation, transmission, storage, and retrieval of multimodal data";
    homepage = "https://docs.docarray.org/";
    changelog = "https://github.com/docarray/docarray/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ loicreynier ];
  };
}
