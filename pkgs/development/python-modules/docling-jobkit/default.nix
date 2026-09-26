{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  boto3,
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
  version = "3.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-jobkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4OUNDn90jGWqHcs9QPpOKqYnKDxH+N/YUeszY21nhMo=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "pandas"
  ];
  dependencies = [
    boto3
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
    ray = [
      msgpack
      psutil
      ray
    ]
    ++ ray.optional-dependencies.serve
    ++ redis.optional-dependencies.hiredis
    ++ lib.optionals ((pythonAtLeast "3.11") && (pythonOlder "3.14")) [
      # cloudflare-sdk
    ];
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky due to comparison with magic object
    # https://github.com/docling-project/docling-jobkit/issues/45
    "test_options_validator"
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
