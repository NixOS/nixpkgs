{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  docling,
  pydantic,
  pydantic-settings,
  typer,
  boto3,
  pandas,
  httpx,

  # optional dependencies
  ray,
  rq,
  msgpack,
  google-api-python-client,
  google-auth-oauthlib,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "docling-jobkit";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-jobkit";
    tag = "v${version}";
    hash = "sha256-uFISZDwj2F9O+3QQiOBApwaPD5ac8C+m+jm9o7SOBnI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    docling
    pydantic
    pydantic-settings
    typer
    boto3
    pandas
    httpx
  ];

  optional-dependencies = {
    ray = [ ray ];
    rq = [
      rq
      msgpack
    ];
    gdrive = [
      google-api-python-client
      google-auth-oauthlib
    ];
  };

  pythonRelaxDeps = [
    "boto3"
    "pandas"
    "pydantic"
  ];

  pythonImportsCheck = [
    "docling"
    "docling_jobkit"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.rq;

  disabledTests = [
    # requires network access
    "test_chunk_file"
    "test_convert_file"
    "test_convert_warmup"
    "test_convert_url"
    "test_replicated_convert"
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
    maintainers = [ ];
  };
}
