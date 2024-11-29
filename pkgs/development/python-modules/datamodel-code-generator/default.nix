{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  pythonOlder,
  gitUpdater,

  # dependencies
  argcomplete,
  black,
  freezegun,
  genson,
  graphql-core,
  httpx,
  inflect,
  isort,
  jinja2,
  mypy,
  openapi-spec-validator,
  packaging,
  prance,
  pre-commit,
  pydantic,
  pysnooper,
  pytest,
  pytest-benchmark,
  # pytest-codspeed,
  pytest-cov,
  pytest-mock,
  pytest-xdist,
  pyyaml,
  ruff,
  ruff-lsp,
  # types-Jinja2,
  types-pyyaml,
  types-setuptools,
  types-toml,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "datamodel-code-generator";
  version = "0.26.3";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    rev = "refs/tags/${version}";
    hash = "sha256-s4m5/rAL7xuXJwEUyJjhS072QGZ+qHgz7bnATS3m/4I=";
  };

  dependencies = [
    pydantic
    argcomplete
    jinja2
    inflect
    black
    isort
    genson
    packaging
    pyyaml
  ] ++ pydantic.optional-dependencies.email;

  optional-dependencies = {
    dev = [
      pytest
      pytest-benchmark
      pytest-cov
      pytest-mock
      mypy
      black
      freezegun
      # types-Jinja2
      types-pyyaml
      types-toml
      types-setuptools
      pydantic
      httpx
      pysnooper
      ruff
      ruff-lsp
      pre-commit
      pytest-xdist
      prance
      openapi-spec-validator
      # pytest-codspeed
    ];

    http = [ httpx ];

    graphql = [ graphql-core ];

    debug = [ pysnooper ];

    validation = [
      prance
      openapi-spec-validator
    ];
  };

  pythonRelaxDeps = [
    "inflect"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  enableParallelBuilding = true;

  doCheck = true;

  pythonImportsCheck = [ "datamodel_code_generator" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Creates pydantic v1 and v2 model, dataclasses.dataclass, typing.TypedDict and msgspec.Struct from an openapi file and others";
    homepage = "https://github.com/koxudaxi/datamodel-code-generator/";
    downloadPage = "https://github.com/koxudaxi/datamodel-code-generator/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
