{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  poetry-core,

  # dependencies
  docling,
  pydantic-settings,
  typer,
  boto3,
  pandas,
  fastparquet,
  pyarrow,
  httpx,

  # optional dependencies
  ray,
  rq,
  msgpack,

  # tests
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "docling-jobkit";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-jobkit";
    tag = "v${version}";
    hash = "sha256-GFta/0Bdu+lN1Yv97t9yVLoWQxkF9CZhBAL88UaaPqw=";
  };

  build-system = [
    hatchling
    poetry-core
  ];

  dependencies = [
    docling
    pydantic-settings
    typer
    boto3
    pandas
    fastparquet
    pyarrow
    httpx
  ];

  optional-dependencies = {
    ray = [ ray ];
    rq = [
      rq
      msgpack
    ];
  };

  pythonImportsCheck = [
    "docling"
    "docling_jobkit"
  ];

  nativeCheckInputs = [
    aiohttp
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.rq;

  disabledTests = [
    # requires network access / remote model downloads
    "test_chunk_file"
    "test_convert_file"
    "test_convert_warmup"
    "test_convert_url"
    "test_replicated_convert"
    "test_clear_converters_clears_caches"
    "test_chunker_manager_shared_across_workers"
    "test_convert_with_callbacks"
    "test_delete_task_cleans_up_job"
    "test_clear_converters_clears_worker_cache"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky due to comparison with magic object
    # https://github.com/docling-project/docling-jobkit/issues/45
    "test_options_validator"
  ];

  meta = {
    changelog = "https://github.com/docling-project/docling-jobkit/blob/${src.tag}/CHANGELOG.md";
    description = "Running a distributed job processing documents with Docling";
    homepage = "https://github.com/docling-project/docling-jobkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
