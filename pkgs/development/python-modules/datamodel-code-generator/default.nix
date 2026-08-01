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
  jsonschema,
  msgspec,
  jinja2,
  openapi-spec-validator,
  packaging,
  prance,
  ruff,
  pydantic,
  pysnooper,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  time-machine,
  watchfiles,
}:

buildPythonPackage rec {
  pname = "datamodel-code-generator";
  version = "0.71.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = version;
    hash = "sha256-0vh/iynZzmMzvdUXNScb+JWANdSrzPLT1qt+jyKleg4=";
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
    hypothesis
    hypothesis-jsonschema
    jsonschema
    msgspec
    pytest-mock
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    time-machine
  ]
  ++ optional-dependencies.all;

  pytestFlags = [
    "--maxfail=2"
  ];

  disabledTests = [
    # remote testing, name resolution failure.
    "test_openapi_parser_parse_remote_ref"
  ];

  pythonImportsCheck = [ "datamodel_code_generator" ];

  meta = {
    description = "Pydantic model and dataclasses.dataclass generator for easy conversion of JSON, OpenAPI, JSON Schema, and YAML data sources";
    homepage = "https://github.com/koxudaxi/datamodel-code-generator";
    changelog = "https://github.com/koxudaxi/datamodel-code-generator/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "datamodel-code-generator";
  };
}
