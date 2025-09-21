{
  argcomplete,
  black,
  buildPythonPackage,
  datamodel-code-generator,
  fetchFromGitHub,
  genson,
  graphql-core,
  hatchling,
  hatch-vcs,
  httpx,
  inflect,
  isort,
  jinja2,
  lib,
  openapi-spec-validator,
  packaging,
  prance,
  pydantic,
  pysnooper,
  pythonOlder,
  pyyaml,
  ruff,
  tomli,
}:

buildPythonPackage rec {
  pname = "datamodel-code-generator";
  version = "0.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = version;
    hash = "sha256-sFMNs8wHRTxK1TU4IWfbKf/qUCb11bh2Td1/FngFavo=";
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "datamodel_code_generator" ];

  optional-dependencies = {
    all = [
      datamodel-code-generator
    ];
    debug = [
      pysnooper
    ];
    graphql = [
      graphql-core
    ];
    http = [
      httpx
    ];
    ruff = [
      ruff
    ];
    validation = [
      openapi-spec-validator
      prance
    ];
  };

  meta = {
    description = "Pydantic model and dataclasses.dataclass generator for easy conversion of JSON, OpenAPI, JSON Schema, and YAML data sources";
    homepage = "https://github.com/koxudaxi/datamodel-code-generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "datamodel-codegen";
  };
}
