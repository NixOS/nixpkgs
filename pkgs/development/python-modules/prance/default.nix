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
  pytestCheckHook,
  openapi-spec-validator,
}:

buildPythonPackage rec {
  pname = "prance";
  version = "23.06.21.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "RonnyPfannschmidt";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-p+LZbQal4DPeMp+eJ2O83rCaL+QIUDcU34pZhYdN4bE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=prance --cov-report=term-missing --cov-fail-under=90" ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    chardet
    packaging
    requests
    ruamel-yaml
    six
  ];

  passthru.optional-dependencies = {
    cli = [ click ];
    flex = [ flex ];
    icu = [ pyicu ];
    osv = [ openapi-spec-validator ];
    ssv = [ swagger-spec-validator ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

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
    changelog = "https://github.com/RonnyPfannschmidt/prance/blob/${src.rev}/CHANGES.rst";
    description = "Resolving Swagger/OpenAPI 2.0 and 3.0.0 Parser";
    mainProgram = "prance";
    homepage = "https://github.com/RonnyPfannschmidt/prance";
    license = licenses.mit;
    maintainers = [ ];
  };
}
