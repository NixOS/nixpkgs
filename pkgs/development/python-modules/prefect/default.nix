{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, aiosqlite
, alembic
, anyio
, apprise
, asgi-lifespan
, asyncpg
, click
, cloudpickle
, coolname
, croniter
, cryptography
, dateparser
, docker
, fsspec
, graphviz
, griffe
, httpcore
, httpx
, jinja2
, jsonpatch
, jsonschema
, kubernetes
, orjson
, packaging
, pathspec
, pendulum
, pydantic
, python-slugify
, pytz
, pyyaml
, readchar
, rich
, ruamel-yaml
, sqlalchemy
, starlette
, toml
, typer
, uvicorn
, websockets
, setuptools

# tests
, pytestCheckHook
, pytest-asyncio
, pytest-cov
, pytest-benchmark
, pytest-env
, pytest-timeout
, pytest-xdist
, flaky
, pillow
, respx
}:

buildPythonPackage rec {
  pname = "prefect";
  version = "2.14.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DOuN8FqE3pndxBJw/POEwoqsHS60i/pULvm98bIIkpc";
  };

  # can be removed once prefect updates for latest anyio
  prePatch = ''
    substituteInPlace src/prefect/engine.py tests/test_context.py \
      --replace "from anyio import start_blocking_portal" "from anyio.from_thread import start_blocking_portal"
    substituteInPlace src/prefect/utilities/asyncutils.py \
      --replace "anyio.start_blocking_portal" "anyio.from_thread.start_blocking_portal"
    substituteInPlace src/prefect/cli/server.py src/prefect/cli/dev.py \
      --replace 'server_env = os.environ.copy()' 'server_env = os.environ.copy(); import sys; server_env["PYTHONPATH"] = ":".join(sys.path)'
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiosqlite
    alembic
    anyio
    apprise
    asgi-lifespan
    asyncpg
    click
    cloudpickle
    coolname
    croniter
    cryptography
    dateparser
    docker
    fsspec
    graphviz
    griffe
    httpcore
    httpx
    jinja2
    jsonpatch
    jsonschema
    kubernetes
    orjson
    packaging
    pathspec
    pendulum
    pydantic
    python-slugify
    pytz
    pyyaml
    readchar
    rich
    ruamel-yaml
    sqlalchemy
    starlette
    toml
    typer
    uvicorn
    websockets
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov
    pytest-benchmark
    pytest-env
    pytest-timeout
    pytest-xdist
    flaky
    pillow
    respx
  ];

  preCheck = "export HOME=$(mktemp -d)";

  # Disabled various tests that fail in nix.
  # Open to contributions to enable more
  disabledTestPaths = [
    "tests/test_artifacts.py"
    "tests/test_deployments.py"
    "tests/test_engine.py"
    "tests/test_filesystems.py"
    "tests/test_flows.py"
    "tests/test_futures.py"
    "tests/test_log_prints.py"
    "tests/test_logging.py"
    "tests/test_states.py"
    "tests/test_task_runners.py"
    "tests/test_tasks.py"
  ];

  disabledTests = [
    "test_put_directory_tree"
    "test_write_outside_of_basepath"
    "test_write_outside_of_basepath_subpath"
    "test_put_directory_put_file_count"
    "test_subprocess_errors_are_surfaced"
    "test_put_directory_flat"
    "test_flow_run_context"
    "test_task_run_context"
    "test_get"
    "test_variables_work_in_sync_flows"
    "test_get_async"
    "test_variables_work_in_async_flows"
  ];

  pythonImportsCheck = [
    "prefect"
  ];

  meta = with lib; {
    changelog = "https://github.com/PrefectHQ/prefect/releases/tag/${version}";
    description = "An orchestrator for data-intensive workflows.";
    homepage = "https://github.com/PrefectHQ/prefect";
    license = licenses.asl20;
    maintainers = with maintainers; [ nviets ];
  };
}
