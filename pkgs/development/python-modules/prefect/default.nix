{
  lib,
  buildPythonPackage,
  fetchPypi,
  whenever,
  pythonOlder,
  pythonAtLeast,

  # build-system
  hatchling,
  versioningit,

  # server deps
  aiosqlite,
  alembic,
  apprise,
  asyncpg,
  click,
  cryptography,
  dateparser,
  docker,
  jinja2,
  jinja2-humanize-extension,
  pytz,
  readchar,
  sqlalchemy,
  typer,

  # client deps
  anyio,
  asgi-lifespan,
  cachetools,
  cloudpickle,
  coolname,
  exceptiongroup,
  fastapi,
  fsspec,
  graphviz,
  griffe,
  httpcore,
  httpx,
  humanize,
  importlib-metadata,
  jsonpatch,
  jsonschema,
  opentelemetry-api,
  orjson,
  packaging,
  pathspec,
  pendulum,
  prometheus-client,
  pydantic,
  pydantic-core,
  pydantic-extra-types,
  pydantic-settings,
  python-dateutil,
  python-slugify,
  python-socks,
  pyyaml,
  rfc3339-validator,
  rich,
  ruamel-yaml,
  sniffio,
  toml,
  typing-extensions,
  uvicorn,
  websockets,
  uv,
  semver,
}:

buildPythonPackage rec {
  pname = "prefect";
  version = "3.4.22";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S0ank+mQekyFObBLsv28YJyYEPaQ12c6O8jQya69/IQ=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    # Server dependencies
    aiosqlite
    alembic
    apprise
    asyncpg
    click
    cryptography
    dateparser
    docker
    jinja2
    jinja2-humanize-extension
    pytz
    readchar
    sqlalchemy
    typer

    # Client dependencies
    anyio
    asgi-lifespan
    cachetools
    cloudpickle
    coolname
    exceptiongroup
    fastapi
    fsspec
    graphviz
    griffe
    httpcore
    httpx
    humanize
    jsonpatch
    jsonschema
    opentelemetry-api
    orjson
    packaging
    pathspec
    pendulum
    prometheus-client
    pydantic
    pydantic-core
    pydantic-extra-types
    pydantic-settings
    python-dateutil
    python-slugify
    python-socks
    pyyaml
    rfc3339-validator
    rich
    ruamel-yaml
    sniffio
    toml
    typing-extensions
    uvicorn
    websockets
    uv
    semver
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    whenever
  ];

  # Tests require network access and complex setup
  doCheck = false;

  pythonImportsCheck = [ "prefect" ];

  meta = with lib; {
    description = "Workflow orchestration framework for building data pipelines in Python";
    homepage = "https://docs.prefect.io";
    changelog = "https://github.com/PrefectHQ/prefect/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "prefect";
  };
}
