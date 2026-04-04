{
  lib,
  argcomplete,
  black,
  buildPythonPackage,
  fetchFromGitHub,
  genson,
  graphql-core,
  hatch-vcs,
  hatchling,
  httpx,
  inflect,
  inline-snapshot,
  isort,
  jinja2,
  openapi-spec-validator,
  packaging,
  prance,
  ruff,
  pydantic,
  pysnooper,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  time-machine,
  watchfiles,
}:

buildPythonPackage rec {
  pname = "datamodel-code-generator";
  version = "0.53.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = version;
    hash = "sha256-9UXlqVikxaO3IaGwcaJYV3HY2YqlgY0zVfb0EI1bFvY=";
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
  ];

  optional-dependencies = {
    all = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "all" ]);
    debug = [ pysnooper ];
    graphql = [ graphql-core ];
    http = [ httpx ];
    ruff = [ ruff ];
    validation = [
      openapi-spec-validator
      prance
    ];
    watch = [
      watchfiles
    ];
  };

  nativeCheckInputs = [
    inline-snapshot
    pytest-mock
    pytestCheckHook
    time-machine
  ]
  ++ optional-dependencies.all;

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
