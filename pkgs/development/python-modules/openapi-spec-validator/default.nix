{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # propagates
  importlib-resources,
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
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  # no tests via pypi sdist
  src = fetchFromGitHub {
    owner = "python-openapi";
    repo = "openapi-spec-validator";
    tag = version;
    hash = "sha256-APEx7+vc824DLmdzLvhfFVrcjPxVwwUwxkh19gjXEvc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    jsonschema
    jsonschema-path
    lazy-object-proxy
    openapi-schema-validator
  ]
  ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

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

  meta = with lib; {
    changelog = "https://github.com/p1c2u/openapi-spec-validator/releases/tag/${src.tag}";
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    mainProgram = "openapi-spec-validator";
    homepage = "https://github.com/p1c2u/openapi-spec-validator";
    license = licenses.asl20;
  };
}
