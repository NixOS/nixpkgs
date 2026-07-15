{
  lib,
  argcomplete,
  black,
  buildPythonPackage,
  email-validator,
  fetchFromGitHub,
  genson,
  graphql-core,
  grpcio-tools,
  hatch-vcs,
  hatchling,
  httpx,
  hypothesis,
  hypothesis-jsonschema,
  inflect,
  inline-snapshot,
  isort,
  jinja2,
  msgspec,
  openapi-spec-validator,
  packaging,
  prance,
  ruff,
  pydantic,
  pysnooper,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  pyyaml,
  time-machine,
  watchfiles,
}:

buildPythonPackage rec {
  pname = "datamodel-code-generator";
  version = "0.68.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = version;
    hash = "sha256-fYnI7S4FJ927qZXyAsWQzxhLTrcpscYqJunmcSt/gkk=";
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
    hypothesis
    hypothesis-jsonschema
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
    protobuf = [ grpcio-tools ];
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
    email-validator
    inline-snapshot
    msgspec
    pytest-mock
    pytest-timeout
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
    changelog = "https://github.com/koxudaxi/datamodel-code-generator/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "datamodel-code-generator";
  };
}
