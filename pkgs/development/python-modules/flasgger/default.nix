{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  flask,
  jsonschema,
  mistune,
  packaging,
  pyyaml,
  six,
  werkzeug,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flasgger";
  version = "0.9.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flasgger";
    repo = "flasgger";
    rev = "v${version}";
    hash = "sha256-ULEf9DJiz/S2wKlb/vjGto8VCI0QDcm0pkU5rlOwtiE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    jsonschema
    mistune
    packaging
    pyyaml
    six
    werkzeug
  ];

  pythonImportsCheck = [ "flasgger" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    "tests"
  ];

  disabledTestPaths = [
    # missing flex dependency
    "tests/test_examples.py"
  ];

  meta = {
    description = "Easy OpenAPI specs and Swagger UI for your Flask API";
    homepage = "https://github.com/flasgger/flasgger/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
