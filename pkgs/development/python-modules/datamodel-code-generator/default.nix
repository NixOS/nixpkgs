{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  argcomplete,
  black,
  genson,
  inflect,
  isort,
  jinja2,
  packaging,
  pydantic,
  pyyaml,

  # optional-dependencies
  # debug:
  pysnooper,
  # graphql:
  graphql-core,
  # http:
  httpx,
  # protobuf:
  grpcio-tools,
  # ruff:
  ruff,
  # validation:
  openapi-spec-validator,
  prance,
  # watch:
  watchfiles,

  # tests
  email-validator,
  hypothesis,
  hypothesis-jsonschema,
  inline-snapshot,
  jsonschema,
  msgspec,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  time-machine,
}:

buildPythonPackage (finalAttrs: {
  pname = "datamodel-code-generator";
  version = "0.71.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = finalAttrs.version;
    hash = "sha256-0vh/iynZzmMzvdUXNScb+JWANdSrzPLT1qt+jyKleg4=";
  };

  build-system = [
    hatch-vcs
    hatchling
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

  optional-dependencies = lib.fix (self: {
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
  });

  nativeCheckInputs = [
    email-validator
    hypothesis
    hypothesis-jsonschema
    inline-snapshot
    jsonschema
    msgspec
    pytest-mock
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    time-machine
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # remote testing, name resolution failure.
    "test_openapi_parser_parse_remote_ref"
  ];

  pythonImportsCheck = [ "datamodel_code_generator" ];

  meta = {
    description = "Pydantic model and dataclasses.dataclass generator for easy conversion of JSON, OpenAPI, JSON Schema, and YAML data sources";
    homepage = "https://github.com/koxudaxi/datamodel-code-generator";
    changelog = "https://github.com/koxudaxi/datamodel-code-generator/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "datamodel-code-generator";
  };
})
