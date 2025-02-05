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
  python3,
  pyyaml,
  toml,
}:

buildPythonPackage rec {
  pname = "datamodel-code-generator";
  version = "0.26.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = version;
    hash = "sha256-CYNEpQFIWR7i7I7YJ5q/34KNhtQ7cjya97Z0fyeO5g8=";
  };

  pythonRelaxDeps = [ "inflect" ];

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
