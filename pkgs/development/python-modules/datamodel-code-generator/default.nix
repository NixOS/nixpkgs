{
  argcomplete,
  black,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  genson,
  graphql-core,
  httpx,
  inflect,
  isort,
  jinja2,
  lib,
  openapi-spec-validator,
  packaging,
  poetry-core,
  poetry-dynamic-versioning,
  prance,
  pytest-mock,
  pytestCheckHook,
  pydantic,
  pyyaml,
  toml,
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

  pythonRelaxDeps = [
    "inflect"
    "isort"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    argcomplete
    black
    genson
    graphql-core
    httpx
    inflect
    isort
    jinja2
    openapi-spec-validator
    packaging
    pydantic
    pyyaml
    toml
  ];

  nativeCheckInputs = [
    freezegun
    prance
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "datamodel_code_generator" ];

  disabledTests = [
    # remote testing, name resolution failure.
    "test_openapi_parser_parse_remote_ref"
  ];

  meta = {
    description = "Pydantic model and dataclasses.dataclass generator for easy conversion of JSON, OpenAPI, JSON Schema, and YAML data sources";
    homepage = "https://github.com/koxudaxi/datamodel-code-generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "datamodel-code-generator";
  };
}
