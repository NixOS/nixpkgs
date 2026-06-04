{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,

  hatchling,

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
  python-dotenv,
  pytz,
  requests,
  rich,
  six,
  sqlalchemy,
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
  version = "1.13.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = finalAttrs.version;
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/dagster";

  build-system = [ hatchling ];

  # Upstream's caps are tighter than nixpkgs' current versions:
  # coloredlogs<=14.0 (nixpkgs ships 15.x) and protobuf<7 (nixpkgs ships 7.x).
  pythonRelaxDeps = [
    "coloredlogs"
    "protobuf"
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
    python-dotenv
    pytz
    requests
    rich
    six
    sqlalchemy
    structlog
    tabulate
    tomli
    toposort
    tqdm
    tzdata
    universal-pathlib
    watchdog
  ];

  # FIXME: upstream test suite needs a full monorepo checkout and many extras;
  # rely on pythonImportsCheck for smoke testing.
  doCheck = false;

  pythonImportsCheck = [ "dagster" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Cloud-native orchestrator for data pipelines";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
    mainProgram = "dagster";
  };
})
