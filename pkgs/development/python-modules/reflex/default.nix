{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  alembic,
  attrs,
  build,
  charset-normalizer,
  dill,
  distro,
  fastapi,
  gunicorn,
  hatchling,
  httpx,
  jinja2,
  lazy-loader,
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
  typing-extensions,
  unzip,
  uvicorn,
  versionCheckHook,
  wheel,
  wrapt,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "reflex";
  version = "0.7.4a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex";
    tag = "v${version}";
    hash = "sha256-KFNcdPoZc+Zps8OV3aLIkk9rlbfy6rx0I9JrYFt2b5E=";
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
    dill
    distro
    fastapi
    gunicorn
    httpx
    jinja2
    lazy-loader
    packaging
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
    typing-extensions
    uvicorn
    wheel
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    playwright
    attrs
    numpy
    plotly
    pandas
    pillow
    unzip
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
