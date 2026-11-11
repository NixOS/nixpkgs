{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  boto3,
  docling-core,
  docling-slim,
  httpx,
  pandas,
  pydantic-settings,

  # optional-dependencies
  # rq:
  rq,
  msgpack,
  # ray:
  redis,
  psutil,
  ray,
  # gdrive:
  google-api-python-client,
  google-auth-oauthlib,
  # gcloudstorage:
  google-cloud-storage,
  # azure:
  azure-storage-blob,
  # opensearch:
  opensearch-py,
  # kafka:
  confluent-kafka,

  # tests
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  starlette,
  redisTestHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-jobkit";
  version = "3.9.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-jobkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tRws9cRy8zEuy16f/ZTAT99SiAfpVKKtwjnVIa6OLFk=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "pandas"
  ];
  dependencies = [
    boto3
    docling-core
    docling-slim
    httpx
    pandas
    pydantic-settings
  ]
  ++ docling-slim.optional-dependencies.standard;

  optional-dependencies = {
    vlm = docling-slim.optional-dependencies.models-vlm-inline;
    rq = [
      rq
      msgpack
    ];
    # codeflare-sdk is not packaged in nixpkgs
    ray = [
      msgpack
      psutil
      ray
    ]
    ++ ray.optional-dependencies.serve
    ++ redis.optional-dependencies.hiredis;
    gdrive = [
      google-api-python-client
      google-auth-oauthlib
    ];
    gcloudstorage = [
      google-cloud-storage
    ];
    azure = [
      azure-storage-blob
    ];
    opensearch = [
      opensearch-py
    ];
    kafka = [
      confluent-kafka
    ];
    # astrapy (astradb), office365-rest-python-client (sharepoint) and boxsdk (box)
    # are not packaged in nixpkgs
  };

  pythonImportsCheck = [
    "docling"
    "docling_jobkit"
  ];

  nativeCheckInputs = [
    aiohttp
    pytest-asyncio
    pytestCheckHook
    ray
    redisTestHook
    starlette
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [
    # Upstream's addopts stop the run after 5 failures
    "--maxfail=0"
  ];

  disabledTests = [
    # requires network access
    "test_chunk_file"
    "test_chunker_manager_shared_across_workers"
    "test_clear_converters_clears_caches"
    "test_convert_file"
    "test_convert_url"
    "test_convert_warmup"
    "test_convert_with_callbacks"
    "test_replicated_convert"
    "test_threaded_request_reaches_conversion"

    # Expect the astradb, box and sharepoint connectors to be registered, but their
    # dependencies are not packaged in nixpkgs
    "test_builtin_source_connectors_registered"
    "test_builtin_target_connectors_registered"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky due to comparison with magic object
    # https://github.com/docling-project/docling-jobkit/issues/45
    "test_options_validator"
  ];

  disabledTestPaths = [
    # astrapy, boxsdk and office365-rest-python-client are not packaged in nixpkgs
    "tests/test_astradb_target_processor.py"
    "tests/test_box_helper.py"
    "tests/test_box_source_processor.py"
    "tests/test_box_target_processor.py"
    "tests/test_sharepoint_coords.py"
    "tests/test_sharepoint_helper.py"
    "tests/test_sharepoint_source_processor.py"
    "tests/test_sharepoint_target_processor.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Running a distributed job processing documents with Docling";
    homepage = "https://github.com/docling-project/docling-jobkit";
    changelog = "https://github.com/docling-project/docling-jobkit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
})
