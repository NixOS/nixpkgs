{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  alembic,
  antlr4-python3-runtime,
  click,
  coloredlogs,
  dagster-pipes,
  dagster-shared,
  docstring-parser,
  filelock,
  grpcio,
  grpcio-health-checking,
  jinja2,
  protobuf,
  psutil,
  python-dateutil,
  python-dotenv,
  pytz,
  requests,
  rich,
  structlog,
  tabulate,
  tomli,
  toposort,
  tqdm,
  tzdata,
  universal-pathlib,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster";
  version = "1.13.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-chQjTEzyV6J24BtmLncLxpq1uu/ydVSHsvSU2fHAtTI=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "coloredlogs" # coloredlogs<=14.0,>=6.1 not satisfied by version 15.0.1
    "protobuf" # protobuf<7,>=4 not satisfied by version 7.34.1
  ];

  dependencies = [
    alembic
    antlr4-python3-runtime
    click
    coloredlogs
    dagster-pipes
    dagster-shared
    docstring-parser
    filelock
    grpcio
    grpcio-health-checking
    jinja2
    protobuf
    psutil
    python-dateutil
    python-dotenv
    pytz
    requests
    rich
    structlog
    tabulate
    tomli
    toposort
    tqdm
    tzdata
    universal-pathlib
    watchdog
  ];

  # Dagster's test suite requires a number of things that don't fit with Nix's sandboxing
  # model, including a running Postgres instance and gRPC servers.
  doCheck = false;

  pythonImportsCheck = [ "dagster" ];

  meta = {
    description = "Orchestration platform for the development, production, and observation of data assets";
    homepage = "https://dagster.io";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lucperkins
    ];
  };
})
