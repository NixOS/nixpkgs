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
  watchdog,
  watchfiles,
  wrapt,
}:

buildPythonPackage rec {
  pname = "reflex";
  version = "0.5.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    rev = "v${version}";
    hash = "sha256-QeEggHPilCLjUQ76AYDkqdf1iWLwCyAYTnf17RdhDq0=";
  };

  pythonRelaxDeps = [ "fastapi" ];
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

  preCheck = ''
    export HOME=$TMP
  '';

  disabledTests = [
    # touches network
    "test_find_and_check_urls"
    "test_event_actions"
    "test_upload_file"
    # /proc is too funky in nix sandbox
    "test_get_cpu_info"
    # broken
    "test_potentially_dirty_substates"
    # flaky, KeyError: 'reflex___state____state'
    "test_preprocess"
  ];
  disabledTestPaths = [
    "benchmarks/"
    "integration/"
  ];

  pythonImportsCheck = [ "reflex" ];

  meta = with lib; {
    description = "Web apps in pure Python";
    homepage = "https://github.com/reflex-dev/reflex";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
