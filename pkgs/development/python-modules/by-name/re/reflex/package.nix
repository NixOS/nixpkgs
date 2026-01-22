{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,
  pre-commit,
  toml,

  # dependencies
  alembic,
  click,
  granian,
  httpx,
  packaging,
  platformdirs,
  psutil,
  pydantic,
  python-multipart,
  python-socketio,
  redis,
  reflex-hosting-cli,
  rich,
  sqlmodel,
  starlette,
  typing-extensions,
  wrapt,

  # tests
  attrs,
  numpy,
  pandas,
  pillow,
  playwright,
  plotly,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-dotenv,
  ruff,
  starlette-admin,
  unzip,
  uvicorn,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "reflex";
  version = "0.8.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pV7J+O7WaD7hzrjvqOFtrj8CKT+SX6KWHot/VxEMtZQ=";
  };

  # For some reason, pre_commit is supposedly missing when python>=3.14
  postPatch = lib.optionalString (pythonAtLeast "3.14") ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pre_commit", ' ""
  '';

  build-system = [
    hatchling
    pre-commit
    toml
  ];

  dependencies = [
    alembic
    click
    granian
    httpx
    packaging
    platformdirs
    psutil
    pydantic
    python-multipart
    python-socketio
    redis
    reflex-hosting-cli
    rich
    sqlmodel
    starlette
    typing-extensions
    wrapt
  ]
  ++ granian.optional-dependencies.reload;

  nativeCheckInputs = [
    attrs
    numpy
    pandas
    pillow
    playwright
    plotly
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    python-dotenv
    ruff
    starlette-admin
    unzip
    uvicorn
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  disabledTests = [
    # Tests touch network
    "test_find_and_check_urls"
    "test_event_actions"
    "test_upload_file"
    "test_node_version"
    # /proc is too funky in nix sandbox
    "test_get_cpu_info"
    # flaky
    "test_preprocess" # KeyError: 'reflex___state____state'
    "test_send" # AssertionError: Expected 'post' to have been called once. Called 0 times.
    # tries to pin the string of a traceback, doesn't account for ansi colors
    "test_state_with_invalid_yield"
    # tries to run bun or npm
    "test_output_system_info"
    # Comparison with magic string
    "test_background_task_no_block"
    # reflex.utils.exceptions.StateSerializationError: Failed to serialize state
    # reflex___istate___dynamic____dill_state due to unpicklable object.
    "test_fallback_pickle"
  ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/integration/"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "reflex" ];

  meta = {
    description = "Web apps in pure Python";
    homepage = "https://github.com/reflex-dev/reflex";
    changelog = "https://github.com/reflex-dev/reflex/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "reflex";
  };
})
