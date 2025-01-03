{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
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
  pytestCheckHook,
  python-engineio,
  python-multipart,
  python-socketio,
  pythonOlder,
  redis,
  reflex-chakra,
  reflex-hosting-cli,
  rich,
  sqlmodel,
  starlette-admin,
  tomlkit,
  twine,
  typer,
  unzip,
  uvicorn,
  watchdog,
  watchfiles,
  wrapt,
}:

buildPythonPackage rec {
  pname = "reflex";
  version = "0.5.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    rev = "refs/tags/v${version}";
    hash = "sha256-8nwVB5FthDbhQRO663vRTqT8KPtStbdSgEoZ75EnhmE=";
  };

  pythonRelaxDeps = [
    "fastapi"
    "gunicorn"
  ];

  pythonRemoveDeps = [
    "setuptools"
    "build"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    alembic
    build # used in custom_components/custom_components.py
    charset-normalizer
    dill
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
    reflex-chakra
    reflex-hosting-cli
    rich
    sqlmodel
    starlette-admin
    tomlkit
    twine # used in custom_components/custom_components.py
    typer
    uvicorn
    watchdog
    watchfiles
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    attrs
    numpy
    plotly
    pandas
    pillow
    unzip
  ];

  disabledTests = [
    # Tests touche network
    "test_find_and_check_urls"
    "test_event_actions"
    "test_upload_file"
    # /proc is too funky in nix sandbox
    "test_get_cpu_info"
    # broken
    "test_potentially_dirty_substates" # AssertionError: Extra items in the left set
    # flaky
    "test_preprocess" # KeyError: 'reflex___state____state'
    "test_send" # AssertionError: Expected 'post' to have been called once. Called 0 times.
  ];

  disabledTestPaths = [
    "benchmarks/"
    "integration/"
  ];

  pythonImportsCheck = [ "reflex" ];

  meta = with lib; {
    description = "Web apps in pure Python";
    homepage = "https://github.com/reflex-dev/reflex";
    changelog = "https://github.com/reflex-dev/reflex/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "reflex";
  };
}
