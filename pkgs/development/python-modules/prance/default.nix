{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  chardet,
  click,
  flex,
  packaging,
  pyicu,
  requests,
  ruamel-yaml,
  setuptools-scm,
  six,
  swagger-spec-validator,
  pytest-cov-stub,
  pytestCheckHook,
  openapi-spec-validator,
}:

buildPythonPackage rec {
  pname = "prance";
  version = "25.04.08.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "RonnyPfannschmidt";
    repo = "prance";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-71M9ufxb0aaSgokThlsTS4ElOJLZntF2TYIErPccQbU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    chardet
    packaging
    requests
    ruamel-yaml
    six
  ];

  optional-dependencies = {
    cli = [ click ];
    flex = [ flex ];
    icu = [ pyicu ];
    osv = [ openapi-spec-validator ];
    ssv = [ swagger-spec-validator ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  # Disable tests that require network
  disabledTestPaths = [ "tests/test_convert.py" ];
  disabledTests = [
    "test_convert_defaults"
    "test_convert_output"
    "test_fetch_url_http"
    "test_openapi_spec_validator_validate_failure"
  ];
  pythonImportsCheck = [ "prance" ];

  meta = with lib; {
    description = "Resolving Swagger/OpenAPI 2.0 and 3.0.0 Parser";
    homepage = "https://github.com/RonnyPfannschmidt/prance";
    changelog = "https://github.com/RonnyPfannschmidt/prance/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "prance";
  };
}
