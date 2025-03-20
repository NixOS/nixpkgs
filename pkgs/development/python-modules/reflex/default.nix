{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  alembic,
  attrs,
  build,
  charset-normalizer,
  dill,
  distro,
  fastapi,
  gunicorn,
  httpx,
  jinja2,
  lazy-loader,
  numpy,
  pandas,
  pillow,
  platformdirs,
  plotly,
  psutil,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  playwright,
  pytestCheckHook,
  python-engineio,
  python-multipart,
  python-socketio,
  pythonOlder,
  redis,
  reflex-hosting-cli,
  rich,
  sqlmodel,
  starlette-admin,
  tomlkit,
  twine,
  typer,
  unzip,
  uvicorn,
  wrapt,
}:

buildPythonPackage rec {
  pname = "reflex";
  version = "0.7.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    tag = "v${version}";
    hash = "sha256-Jia8WrzxaPFg3wDEgxiSc1e1q1HtSPHrJTyfBkU1PUo=";
  };

  pythonRelaxDeps = [
    "fastapi"
    "gunicorn"
  ];

  pythonRemoveDeps = [
    "setuptools"
    "build"
  ];

  build-system = [ hatchling ];

  dependencies = [
    alembic
    build # used in custom_components/custom_components.py
    charset-normalizer
    distro
    fastapi
    gunicorn
    httpx
    jinja2
    lazy-loader
    platformdirs
    psutil
    pydantic
    python-engineio
    python-multipart
    python-socketio
    redis
    reflex-hosting-cli
    rich
    sqlmodel
    starlette-admin
    tomlkit
    twine # used in custom_components/custom_components.py
    typer
    uvicorn
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    dill
    playwright
    attrs
    numpy
    plotly
    pandas
    pillow
    unzip
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # Tests touch network
    "test_find_and_check_urls"
    "test_event_actions"
    "test_upload_file"
    "test_node_version"
    # /proc is too funky in nix sandbox
    "test_get_cpu_info"
    # broken
    "test_potentially_dirty_substates" # AssertionError: Extra items in the left set
    # flaky
    "test_preprocess" # KeyError: 'reflex___state____state'
    "test_send" # AssertionError: Expected 'post' to have been called once. Called 0 times.
    # tries to pin the string of a traceback, doesn't account for ansi colors
    "test_state_with_invalid_yield"
  ];

  disabledTestPaths = [
    "tests/benchmarks/"
    "tests/integration/"
  ];

  pythonImportsCheck = [ "reflex" ];

  meta = with lib; {
    description = "Web apps in pure Python";
    homepage = "https://github.com/reflex-dev/reflex";
    changelog = "https://github.com/reflex-dev/reflex/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "reflex";
  };
}
