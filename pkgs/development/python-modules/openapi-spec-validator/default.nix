{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # propagates
  jsonschema,
  jsonschema-path,
  lazy-object-proxy,
  openapi-schema-validator,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.8.4";
  pyproject = true;

  # no tests via pypi sdist
  src = fetchFromGitHub {
    owner = "python-openapi";
    repo = "openapi-spec-validator";
    tag = version;
    hash = "sha256-KY9mDnF/R2UO8WZ0WyBzpZQsVBxzxnTK6zyqvUb+hVw=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "jsonschema"
  ];

  dependencies = [
    jsonschema
    jsonschema-path
    lazy-object-proxy
    openapi-schema-validator
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTests = [
    # network access
    "test_default_valid"
    "test_urllib_valid"
    "test_valid"
  ];

  pythonImportsCheck = [
    "openapi_spec_validator"
    "openapi_spec_validator.readers"
  ];

  meta = {
    changelog = "https://github.com/p1c2u/openapi-spec-validator/releases/tag/${src.tag}";
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    mainProgram = "openapi-spec-validator";
    homepage = "https://github.com/p1c2u/openapi-spec-validator";
    license = lib.licenses.asl20;
  };
}
