{
  lib,
  argcomplete,
  black,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  genson,
  graphql-core,
  hatch-vcs,
  hatchling,
  httpx,
  inflect,
  isort,
  jinja2,
  openapi-spec-validator,
  packaging,
  prance,
  ruff,
  pydantic,
  pytest-benchmark,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  toml,
  time-machine,
  inline-snapshot,
  watchfiles,
}:

buildPythonPackage rec {
  pname = "datamodel-code-generator";
  version = "0.52.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = version;
    hash = "sha256-zkHqzAaEZdXt8EZVeS8lCkojaWa9EnzVXn+sxmvEv0U=";
  };

  pythonRelaxDeps = [
    "inflect"
    "isort"
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    argcomplete
    black
    genson
    inflect
    isort
    jinja2
    packaging
    pydantic
    pyyaml
    toml
  ];

  optional-dependencies = {
    graphql = [ graphql-core ];
    http = [ httpx ];
    ruff = [ ruff ];
    validation = [
      openapi-spec-validator
      prance
    ];
  };

  nativeCheckInputs = [
    freezegun
    pytest-benchmark
    pytest-mock
    pytestCheckHook
    time-machine
    inline-snapshot
    watchfiles
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "datamodel_code_generator" ];

  disabledTests = [
    # remote testing, name resolution failure.
    "test_openapi_parser_parse_remote_ref"
  ];

  meta = {
    description = "Pydantic model and dataclasses.dataclass generator for easy conversion of JSON, OpenAPI, JSON Schema, and YAML data sources";
    homepage = "https://github.com/koxudaxi/datamodel-code-generator";
    changelog = "https://github.com/koxudaxi/datamodel-code-generator/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "datamodel-code-generator";
  };
}
