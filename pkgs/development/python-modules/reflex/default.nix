{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  alembic,
  attrs,
  build,
  ruff,
  dill,
  granian,
  hatchling,
  httpx,
  numpy,
  packaging,
  pandas,
  pillow,
  platformdirs,
  playwright,
  plotly,
  psutil,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  python-dotenv,
  pytestCheckHook,
  python-multipart,
  python-socketio,
  redis,
  reflex-hosting-cli,
  rich,
  sqlmodel,
  starlette-admin,
  stdenv,
  typer,
  typing-extensions,
  unzip,
  uvicorn,
  versionCheckHook,
  wrapt,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "reflex";
  version = "0.8.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    tag = "v${version}";
    hash = "sha256-w3qikUqo61UBJHVjbzeNCf97AZyBHLI+PkkXrVQBNAk=";
  };

  # 'rich' is also somehow checked when building the wheel,
  # pythonRelaxDepsHook modifies the wheel METADATA in postBuild
  pypaBuildFlags = [ "--skip-dependency-check" ];

  pythonRelaxDeps = [
    # needed
    "click"
    "starlette"
    "rich"
  ];

  build-system = [ hatchling ];

  dependencies = [
    alembic
    build # used in custom_components/custom_components.py
    dill # used in state.py
    granian
    granian.optional-dependencies.reload
    httpx
    packaging # used in utils/prerequisites.py
    platformdirs
    psutil
    pydantic
    python-multipart
    python-socketio
    redis
    reflex-hosting-cli
    rich
    sqlmodel
    typer # optional dep
    typing-extensions
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    python-dotenv
    ruff
    playwright
    attrs
    numpy
    plotly
    pandas
    pillow
    unzip
    uvicorn
    starlette-admin
    writableTmpDirAsHomeHook
    versionCheckHook
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted (fails in sandbox)
    "test_is_process_on_port_free_port"
    "test_is_process_on_port_occupied_port"
    "test_is_process_on_port_both_protocols"
    "test_is_process_on_port_concurrent_access"
  ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/integration/"
  ];

  pythonImportsCheck = [ "reflex" ];

  meta = {
    description = "Web apps in pure Python";
    homepage = "https://github.com/reflex-dev/reflex";
    changelog = "https://github.com/reflex-dev/reflex/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "reflex";
  };
}
